local wezterm = require 'wezterm'
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { 'hostname' },
    tabline_b = { 'domain' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'process', padding = 0 }
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { '' },
    tabline_y = { 'datetime' },
    tabline_z = { '' },
  },
  extensions = {},
})

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_prog = { 'C:/Program Files/PowerShell/7/pwsh.exe', '-l'}
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 140
config.initial_rows = 40
config.enable_wayland = true
config.font = wezterm.font('Terminess Nerd Font')
config.font_size = 17

-- Window
config.window_padding = { left = 5, right = 5, top = 5, bottom = 0 }
config.window_background_opacity = 0.90
config.window_decorations = "RESIZE"


-- Colors
config.colors = {
    foreground = "#c0c0c0", -- Light grey
    background = "#000000", -- Black
    cursor_bg = "#ff00ff",  -- Magenta
    cursor_border = "#ff00ff", -- Magenta
    cursor_fg = "#000000", -- Black (cursor text color)
    selection_bg = "#44475a",
    selection_fg = "#ffffff",

    -- Normal colors
    ansi = {
      "#000000", -- black
      "#ff5555", -- red
      "#50fa7b", -- green
      "#f1fa8c", -- yellow
      "#bd93f9", -- blue
      "#ff79c6", -- magenta
      "#8be9fd", -- cyan
      "#bbbbbb", -- white
    },
    -- Bright colors
    brights = {
      "#44475a", -- bright black (grey)
      "#ff6e6e", -- bright red
      "#69ff94", -- bright green
      "#ffffa5", -- bright yellow
      "#d6acff", -- bright blue
      "#ff92d0", -- bright magenta
      "#a4ffff", -- bright cyan
      "#ffffff", -- bright white
    },
  }

--Keybindings
config.keys = {
    {key="v", mods="CTRL|SHIFT", action=wezterm.action{PasteFrom="Clipboard"}},
    {key="c", mods="CTRL|SHIFT", action=wezterm.action{CopyTo="Clipboard"}},
    {key="=", mods="CTRL", action="IncreaseFontSize"},
    {key="-", mods="CTRL", action="DecreaseFontSize"},
  }

-- Tabs
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 25
config.hide_tab_bar_if_only_one_tab = false

return config
