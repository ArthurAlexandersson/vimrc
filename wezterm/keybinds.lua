local wezterm = require 'wezterm'
local mytable = require 'lib/mystdlib'.mytable

local config = {}

-- leader key
config.leader = {
	key = ' ',
	mods = 'CTRL',
	timeout_milliseconds = 2000,
}


-- load workspace plugin
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.apply_to_config(config)

-- path to zoxide
workspace_switcher.zoxide_path = '/home/arthur/.local/bin/zoxide'

-- keybindings
config.keys = {
	-- search for things that look like git hashes
	{
		key = 'H',
		mods = 'SHIFT|CTRL',
		action = wezterm.action.Search {
		  Regex = '[a-f0-9]{6,}',
		},
	},
	-- search for the lowercase string "hash" matching the case exactly
	{
		key = 'H',
		mods = 'SHIFT|CTRL',
		action = wezterm.action.Search { CaseSensitiveString = 'hash' },
	},
	-- search for the string "hash" matching regardless of case
	{
		key = 'H',
		mods = 'SHIFT|CTRL',
		action = wezterm.action.Search { CaseInSensitiveString = 'hash' },
	},
	-- set leader key
	{
		key = '[',
		mods = 'LEADER',
		action = wezterm.action.ActivateCopyMode,
	},

	-- pane splitting
	{
		key = '%',
		mods = 'LEADER|SHIFT',
		action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},
	{
		key = '"',
		mods = 'LEADER|SHIFT',
		action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
	},

	-- pane shifting
	{
		key = 'h',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection 'Left',
	},
	{
		key = 'j',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection 'Down',
	},
	{
		key = 'k',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection 'Up',
	},
	{
		key = 'l',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection 'Right',
	},
	{
		key = 'q',
		mods = 'LEADER',
		action = wezterm.action.ActivateKeyTable{
			name = 'pane-mode',
			one_shot = true,
		}
	},

	-- tabs
	{
		key = 'c',
		mods = 'LEADER',
		action = wezterm.action.SpawnTab 'CurrentPaneDomain',
	},
	{
		key = 'n',
		mods = 'LEADER',
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = ',',
		mods = 'LEADER',
		action = wezterm.action.PromptInputLine {
		  description = 'Enter new name for tab',
		  action = wezterm.action_callback(
			function(window, pane, line)
			  if line then
				window:active_tab():set_title(line)
			  end
			end
		  ),
		},
	},
	{
		key = 'p',
		mods = 'LEADER',
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = 'w',
		mods = 'LEADER',
		action = wezterm.action.ShowTabNavigator,
	},
	{
		key = 'x',
		mods = 'LEADER',
		action = wezterm.action.CloseCurrentTab { confirm = true },
	},

	-- zooming
	{
		key = 'z',
		mods = 'LEADER',
		action = wezterm.action.TogglePaneZoomState,
	},

	-- workspace switching
	{
		key = 's',
		mods = 'LEADER',
		action = workspace_switcher.switch_workspace(),
	}, 

	{
		key = 't',
		mods = 'LEADER',
		action = wezterm.action.ShowLauncherArgs({flags = 'FUZZY|WORKSPACES'}),
	}



}

-- Add LEADER + number to activate specific pane by index
config.key_tables = {
  ['pane-mode'] = {},
}

for i = 0, 9 do
	table.insert(config.key_tables['pane-mode'], {
		key = tostring(i),
		action = wezterm.action.ActivatePaneByIndex(i),
	})
end

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = 'LEADER',
		action = wezterm.action.ActivateTab(i-1),
	})
end

for i = 1, 9 do
  -- CTRL+ALT + number to move to that position
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = wezterm.action.MoveTab(i - 1),
  })
end

config.keys = mytable.flatten_list(config.keys)

return config
