-- Resolve paths without relying on launchd's minimal environment.
local home_dir = os.getenv("HOME") or ""
local config_dir = os.getenv("CONFIG_DIR") or (home_dir .. "/.config/sketchybar")
package.cpath = package.cpath .. ";" .. home_dir .. "/.local/share/sketchybar_lua/?.so"

os.execute("(cd " .. config_dir .. "/helpers && make)")
