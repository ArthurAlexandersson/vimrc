local wezterm = require 'wezterm'
local mytable = require 'lib/mystdlib'.mytable

local config_misc = {
	-- general settings
	window_decorations = "NONE",

	-- colors 
	color_scheme = 'Catppuccin Mocha',
}

-- print workspace on top right side
wezterm.on("update-right-status", function(window, pane)
	local workspace = window:active_workspace()

	window:set_right_status(wezterm.format({
		{ Background = { Color = "none" } }, -- Transparent background
		-- { Foreground = { Color = "#c0c0c0" } }, -- Light gray text (change as you like)
		{ Text = "󰓩  " .. workspace }, -- Add an icon or just use workspace name
	}))
end)

local full_config = mytable.merge_all(
	config_misc, 
	require('keybinds'),
	{}
)

return full_config

