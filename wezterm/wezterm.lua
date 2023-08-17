-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

local enable_tmux_like_keymaps = false

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
}

if enable_tmux_like_keymaps then
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 50000 }
  local tmux_keymap = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
      key = "a",
      mods = "LEADER|CTRL",
      action = act.SendKey { key = "a", mods = "CTRL" },
    },
    {
      key = '"',
      mods = "LEADER",
      action = act.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
      key = "%",
      mods = "LEADER",
      action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    {
      key = "-",
      mods = "LEADER",
      action = act.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
      key = "|",
      mods = "LEADER",
      action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
    {
      key = "c",
      mods = "LEADER",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "h",
      mods = "CTRL",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "j",
      mods = "CTRL",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "k",
      mods = "CTRL",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "l",
      mods = "CTRL",
      action = act.ActivatePaneDirection("Right"),
    },
    {
      key = "H",
      mods = "LEADER",
      action = act.AdjustPaneSize { "Left", 5 },
    },
    {
      key = "J",
      mods = "LEADER",
      action = act.AdjustPaneSize { "Down", 5 },
    },
    {
      key = "K",
      mods = "LEADER",
      action = act.AdjustPaneSize { "Up", 5 },
    },
    {
      key = "L",
      mods = "LEADER",
      action = act.AdjustPaneSize { "Right", 5 },
    },
    {
      key = "&",
      mods = "LEADER",
      action = act.CloseCurrentTab { confirm = true },
    },
    {
      key = "x",
      mods = "LEADER",
      action = act.CloseCurrentPane { confirm = true },
    },
    {
      key = "p",
      mods = "LEADER",
      action = act.ActivateTabRelative(-1),
    },
    {
      key = "n",
      mods = "LEADER",
      action = act.ActivateTabRelative(1),
    },
    {
      key = ";",
      mods = "CTRL",
      action = act.ActivatePaneDirection("Next"),
    },
    { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
    { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
    { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
    { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
    { key = "9", mods = "LEADER", action = act.ActivateTab(8) },
    { key = "PageUp", action = act.ScrollByPage(-0.5) },
    { key = "PageDown", action = act.ScrollByPage(0.5) },
  }
  for i = 1, #tmux_keymap do
    table.insert(config.keys, tmux_keymap[i])
  end
end

-- and finally, return the configuration to wezterm
return config
