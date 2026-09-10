local sbar = require("sketchybar")
local colors = require("appearance").colors

-- Single seamless border around the right-side widgets
sbar.add("bracket", "widgets.right.bracket", {
	"widgets.calendar",
	"widgets.spotify",
	"widgets.battery",
	"widgets.volume1",
	"widgets.volume2",
}, {
	background = {
		drawing = true,
		color = colors.bg2,
		border_color = colors.macchiato.surface0,
		border_width = 1,
		height = 30,
		corner_radius = 10,
	},
	blur_radius = 20,
})

-- The inner volume bracket is only a popup anchor; keep its background hidden
sbar.set("widgets.volume.bracket", { background = { drawing = "off" } })
