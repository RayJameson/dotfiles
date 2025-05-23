-- Pull in the wezterm API
local wezterm = require("wezterm") --[[@type Wezterm]]
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
wezterm.on("toggle-transparency", function()
  if wezterm.GLOBAL.window_background_opacity == transparency_value or wezterm.GLOBAL.window_background_opacity == nil then
    wezterm.GLOBAL.window_background_opacity = 1
  elseif wezterm.GLOBAL.window_background_opacity == 1 then
    wezterm.GLOBAL.window_background_opacity = transparency_value
  end
  wezterm.reload_configuration()
end)
-- Check current OS and apply background effects
---@type FontAttributes
---@diagnostic disable-next-line: missing-fields
local font_attributes = {
  family = "Iosevka Nerd Font Mono",
  weight = "ExtraLight",
  stretch = "Condensed",
  freetype_load_flags = "NO_HINTING",
}
if wezterm.target_triple:match("darwin") then
  config.macos_window_background_blur = 20
  config.font_size = 24.5
elseif wezterm.target_triple:match("windows") then
  ---@diagnostic disable-next-line: assign-type-mismatch
  config.win32_system_backdrop = "Acrylic"
  config.term = "" -- Set to empty so FZF works on windows
  config.default_prog = { "pwsh.exe" }
elseif wezterm.target_triple:match("linux") then
  config.font_size = 18.5
end

config.use_fancy_tab_bar = false
config.tab_max_width = 25
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

---@diagnostic disable-next-line: param-type-mismatch, redundant-parameter, assign-type-mismatch
config.font = wezterm.font(font_attributes)
if font_attributes.family:match("[Nn]erd") then
  config.set_environment_variables = {
    NERD_FONT = font_attributes.family,
  }
end
--<!-- -- != := === == != >= >- >=> |-> -> <$> </> #[ |||> |= ~@

config.color_scheme = "Dracula (Official)"
---@diagnostic disable-next-line: missing-fields
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

---@diagnostic disable-next-line: assign-type-mismatch
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
