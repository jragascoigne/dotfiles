#!/usr/bin/env bash
set -euo pipefail

version="2.24.0"
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_bin="${1:-$HOME/.local/bin/sketchybar}"
build_dir="$(mktemp -d "${TMPDIR:-/tmp}/sketchybar-build.XXXXXX")"
trap 'rm -rf "$build_dir"' EXIT

curl -fsSL "https://github.com/FelixKratz/SketchyBar/archive/refs/tags/v${version}.tar.gz" \
  | tar -xz -C "$build_dir"

source_dir="$build_dir/SketchyBar-${version}"
patch -d "$source_dir" -p1 < "$repo_dir/patches/sketchybar-marquee.patch"
make -C "$source_dir"

mkdir -p "$(dirname "$output_bin")"
install -m 755 "$source_dir/bin/sketchybar" "$output_bin"
codesign --force --sign - "$output_bin"
printf 'Installed patched SketchyBar at %s\n' "$output_bin"
