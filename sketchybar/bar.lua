local colors = require("appearance")
local settings = require("settings")
local sbar = require("sketchybar")

-- Equivalent to the --bar domain
sbar.bar({
	color = colors.colors.bar.bg,
	height = settings.height,
	notch_display_height = settings.height,
	padding_right = 10,
	padding_left = 10,
	sticky = "on",
	topmost = "window",
	y_offset = 0,
	blur_radius = 20,
})
