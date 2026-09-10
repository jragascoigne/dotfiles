# dotfiles

A compact macOS SketchyBar configuration with Aerospace workspaces, a right-side Spotify now-playing widget, teal accents, and a 38 px bar.

## What is included

- Spotify title updates via Spotify's playback-change notification, hides when nothing is playing, and has a slow reversible marquee.
- Space Mono typography, with italics limited to Spotify, the focused app label, and the date.
- Aerospace workspace and current-app display.
- Battery, volume, date, and time widgets.
- A pinned SketchyBar `v2.24.0` source patch that makes the marquee scroll by pixels, pause for two seconds at either end, reverse, and reset whenever text changes.

## Install

Requirements: macOS, Xcode Command Line Tools, Homebrew, and Aerospace. Install the **Space Mono** and **Hack Nerd Font** fonts before starting.

```sh
git clone <your-repository-url> ~/dotfiles/sketchybar
cd ~/dotfiles/sketchybar
./install.sh
```

The installer installs SketchyBar, Lua, and the SbarLua module; preserves an existing `~/.config/sketchybar` as a timestamped backup; builds the patched SketchyBar binary; links this repo as the live configuration; and launches it using a user LaunchAgent.

The build downloads public source during installation. It does not use or distribute a machine-specific binary.

For instant workspace updates, merge `aerospace.toml.snippet` into `~/.aerospace.toml`, then run `aerospace reload-config`.

## Customize

| Change | File |
| --- | --- |
| Colours | `sketchybar/appearance.lua` |
| Fonts and italic rules | `sketchybar/fonts.lua` |
| Bar height and spacing | `sketchybar/settings.lua` |
| Spotify widget | `sketchybar/items/spotify.lua` |
| Date and time | `sketchybar/items/calendar.lua` |
| Aerospace workspace/current-app display | `sketchybar/items/spaces.lua` |

After editing, reload with:

```sh
sketchybar --reload
```

## Notes

This intentionally includes only the active configuration. Unused plugins and machine-specific integrations were excluded, including old paths and any potential personal-service configuration.

The marquee behavior is implemented by `patches/sketchybar-marquee.patch`. To change its endpoint pause, edit the two `120` frame values in that patch, then re-run `./scripts/build-patched-sketchybar.sh` and restart the LaunchAgent.
