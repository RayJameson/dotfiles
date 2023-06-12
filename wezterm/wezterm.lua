-- Pull in the wezterm API
local wezterm = require("wezterm")

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
end

config.enable_tab_bar = false

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

local act = wezterm.action

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
}

-- and finally, return the configuration to wezterm
return config
