local colors = require("appearance").colors
local fonts = require("fonts")
local sbar = require("sketchybar")

local spotify = sbar.add("item", "widgets.spotify", {
	position = "right",
	drawing = true,
	update_freq = 1,
	scroll_texts = true,
	icon = {
		string = "",
		font = { family = fonts.font_icon.text, style = "Bold", size = 16.0 },
		color = colors.accent,
		padding_left = 8,
		padding_right = 4,
	},
	label = {
		string = "",
		max_chars = 12,
		scroll_duration = 300,
		font = { family = fonts.font.text, style = "Bold Italic", size = 13.0 },
		padding_left = 0,
		padding_right = 8,
	},
	background = { drawing = "off" },
})

local function show_track(track)
	spotify:set({
		drawing = track ~= "",
		label = { string = track },
	})
end

-- Spotify emits this notification whenever playback or the current track changes.
sbar.add("event", "spotify_playback_change", "com.spotify.client.PlaybackStateChanged")

local function update_spotify()
	sbar.exec([[pgrep -x Spotify >/dev/null && osascript -e 'tell application "Spotify"' -e 'if player state is playing then' -e 'return artist of current track & " - " & name of current track' -e 'end if' -e 'end tell' 2>/dev/null]], function(result)
		local track = result:gsub("[\r\n]+$", "")
		show_track(track)
	end)
end

spotify:subscribe("media_change", function(env)
	local info = env.INFO
	local playing = info and info.app == "Spotify" and info.state == "playing"
	show_track(playing and (info.artist .. " - " .. info.title) or "")
end)

spotify:subscribe({ "routine", "system_woke", "forced", "spotify_playback_change" }, update_spotify)
update_spotify()
