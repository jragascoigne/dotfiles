#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="$HOME/.config/sketchybar"
binary="$HOME/.local/bin/sketchybar"
plist="$HOME/Library/LaunchAgents/com.sketchybar.dotfiles.plist"

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This configuration is for macOS." >&2
  exit 1
fi

if ! command -v brew >/dev/null; then
  echo "Homebrew is required: https://brew.sh" >&2
  exit 1
fi

brew tap FelixKratz/formulae
brew install sketchybar lua

if [[ ! -f "$HOME/.local/share/sketchybar_lua/sketchybar.so" ]]; then
  lua_build="$(mktemp -d "${TMPDIR:-/tmp}/sbarlua.XXXXXX")"
  trap 'rm -rf "$lua_build"' EXIT
  git clone --depth 1 https://github.com/FelixKratz/SbarLua.git "$lua_build/SbarLua"
  make -C "$lua_build/SbarLua" install
fi

mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/Library/LaunchAgents"
if [[ -e "$config_dir" && ! -L "$config_dir" ]]; then
  backup="${config_dir}.backup-$(date +%Y%m%d%H%M%S)"
  mv "$config_dir" "$backup"
  echo "Backed up existing config to $backup"
fi
ln -sfn "$repo_dir/sketchybar" "$config_dir"

"$repo_dir/scripts/build-patched-sketchybar.sh" "$binary"
sed -e "s|__SKETCHYBAR_BIN__|$binary|g" \
    -e "s|__CONFIG_DIR__|$config_dir|g" \
    "$repo_dir/launchd/com.sketchybar.dotfiles.plist.template" > "$plist"

launchctl bootout "gui/$(id -u)" "$plist" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$plist"
echo "SketchyBar is installed and running. Install Space Mono and Hack Nerd Font for the intended appearance."
