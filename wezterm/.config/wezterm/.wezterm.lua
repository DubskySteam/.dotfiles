local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_prog = { 'C:/Program Files/PowerShell/7/pwsh.exe', '-l'}
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 140
config.initial_rows = 40
config.enable_wayland = true
config.window_background_opacity = 0.90
config.font = wezterm.font('Terminess Nerd Font')
config.font_size = 17

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
config.use_fancy_tab_bar = true
config.tab_bar_style = {
        window_hide = " minimize ",
        window_maximize = " maximize ",
        window_close = " close ",

        window_close_hover = " CLOSE ",
        window_hide_hover = " MINIMIZE ",
        window_maximize_hover = " MAXIMIZE ",
    }
window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"

return config
