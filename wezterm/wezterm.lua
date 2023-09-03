-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end
-- This is where you actually apply your config choices
config.window_background_opacity = 0.7

-- Check current OS and apply background effects
if wezterm.target_triple:match("darwin") then
  config.macos_window_background_blur = 30
elseif wezterm.target_triple:match("windows") then
  config.win32_system_backdrop = "Acrylic"
  config.term = "" -- Set to empty so FZF works on windows
  config.default_prog = { "pwsh.exe" }
end

-- config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_max_width = 25
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.harfbuzz_features = { "zero" } -- zero with dot instead of slashed zero
config.font = wezterm.font("LigaMesloLGSDZ Nerd Font Mono")
--<!-- -- != := === == != >= >- >=> |-> -> <$> </> #[ |||> |= ~@

config.font_size = 20
config.freetype_load_flags = "NO_HINTING"

-- For example, changing the color scheme:
config.color_scheme = "Dracula (Official)"
config.colors = {
  visual_bell = "grey",
}
config.window_decorations = "RESIZE"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.window_padding = {
  left = "0cell",
  right = "0cell",
  top = "0.0cell",
  bottom = "0.0cell",
}

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 50,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 50,
}
config.keys = {
  -- Rebind CTRL-SHIFT <-/-> to match TMUX keybindings
  {
    key = "LeftArrow",
    mods = "SHIFT|CTRL",
    action = act.SendKey {
      key = "LeftArrow",
      mods = "SHIFT|CTRL",
    },
  },
  {
    key = "RightArrow",
    mods = "SHIFT|CTRL",
    action = act.SendKey {
      key = "RightArrow",
      mods = "SHIFT|CTRL",
    },
  },
  -- allow tmux to receive <C-'>/<C-;>/<C-,> binding
  { key = "'", mods = "CTRL", action = wezterm.action.SendString("\x1b[27;5;39~") },
  { key = ";", mods = "CTRL", action = wezterm.action.SendString("\x1b[27;5;59~") },
  { key = "-", mods = "CTRL", action = wezterm.action.SendString("\x1b[27;5;45~") },
  { key = "=", mods = "CTRL", action = wezterm.action.SendString("\x1b[27;5;61~") },
  { key = ",", mods = "CTRL", action = wezterm.action.SendString("\x1b[27;5;44~") },
}

-- and finally, return the configuration to wezterm
return config
