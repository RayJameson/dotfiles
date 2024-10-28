-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end
local transparency_value = 0.7
config.window_background_opacity = wezterm.GLOBAL.window_background_opacity or transparency_value
-- This is where you actually apply your config choices
wezterm.on("toggle-transparency", function(window, _)
  if wezterm.GLOBAL.window_background_opacity == transparency_value or wezterm.GLOBAL.window_background_opacity == nil then
    wezterm.GLOBAL.window_background_opacity = 1
  elseif wezterm.GLOBAL.window_background_opacity == 1 then
    wezterm.GLOBAL.window_background_opacity = transparency_value
  end
  wezterm.reload_configuration()
end)
local font_name
-- Check current OS and apply background effects
if wezterm.target_triple:match("darwin") then
  config.macos_window_background_blur = 30
  config.font_size = 24
  font_name = "Iosevka Nerd Font Mono SemiCondensed Light"
elseif wezterm.target_triple:match("windows") then
  font_name = "Iosevka Nerd Font Mono SemiCondensed Light"
  config.win32_system_backdrop = "Acrylic"
  config.term = "" -- Set to empty so FZF works on windows
  config.default_prog = { "pwsh.exe" }
elseif wezterm.target_triple:match("linux") then
  config.font_size = 16
  font_name = "Iosevka Nerd Font Mono Condensed ExtraLight"
end

-- config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_max_width = 25
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- config.harfbuzz_features = { "zero" } -- zero with dot instead of slashed zero
-- local font_name = "LigaMesloLGSDZ Nerd Font Mono"
--
config.font = wezterm.font(font_name)
if font_name:match("[Nn]erd") then
  config.set_environment_variables = {
    NERD_FONT = font_name,
  }
end
--<!-- -- != := === == != >= >- >=> |-> -> <$> </> #[ |||> |= ~@

config.freetype_load_flags = "NO_HINTING"

-- For example, changing the color scheme:
config.color_scheme = "Dracula (Official)"
config.colors = {
  visual_bell = "grey",
  background = "#1e222a",
}
config.window_decorations = "RESIZE"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
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
  {
    key = "t",
    mods = "SUPER|ALT",
    action = wezterm.action.EmitEvent("toggle-transparency"),
  },
}

-- and finally, return the configuration to wezterm
return config
