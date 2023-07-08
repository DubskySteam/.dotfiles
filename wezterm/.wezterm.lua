local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_prog = { 'C:/Program Files/PowerShell/7/pwsh.exe', '-l'}
config.hide_tab_bar_if_only_one_tab = true

font = wezterm.font('JetBrains Mono Nerd Font')

config.colors = {
	foreground = 'white',
	background = '#252422',
	cursor_fg = 'black',
	cursor_bg = '#fa003f',

	split = 'white'
}
return config
