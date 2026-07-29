-- rules.lua
-- WINDOWS AND WORKSPACES
local waybar_gap = 30

hl.window_rule {
  name = "default-no-blur",
  no_blur = true,
  suppress_event = "maximize",
  idle_inhibit = "fullscreen",
  match = { class = ".*", tag = "negative:blurry" },
}

-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
-- See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
hl.window_rule {
  name = "copyq",
  float = true,
  center = true,
  no_dim = true,
  group = "deny",
  size = { "monitor_w*0.35", "monitor_h*0.65" },
  match = { class = "^com.github.hluk.copyq$" },
}

hl.window_rule {
  name = "viewnior",
  float = true,
  size = { "monitor_w*0.75", "monitor_h*0.75" },
  match = { class = "^viewnior$" },
}

hl.window_rule {
  name = "portproton",
  float = true,
  match = { class = "^PortProton$" },
}

hl.window_rule {
  name = "browser-pip",
  float = true,
  move = { "monitor_w-window_w-4", "monitor_h-window_h-4" },
  pin = true,
  no_dim = true,
  keep_aspect_ratio = true,
  no_follow_mouse = true,
  no_initial_focus = true,
  group = "deny",
  suppress_event = "activatefocus",
  match = { title = "^Picture-in-Picture$" },
}

hl.window_rule {
  name = "mpv",
  pin = true,
  no_dim = true,
  keep_aspect_ratio = true,
  no_follow_mouse = true,
  no_initial_focus = true,
  match = { class = "^mpv$" },
}

hl.window_rule {
  name = "steam-other-windows",
  tag = "+popup",
  match = { class = "^steam$", title = "^$", float = true },
}

hl.window_rule {
  name = "pdf-reader",
  tag = "+popup",
  match = { class = "^pdf$" },
}

hl.window_rule {
  name = "proton-fixes",
  tag = "+popup",
  match = { title = "^ProtonFixes$", class = "^zenity$" },
  float = true,
  group = "deny",
}

hl.window_rule {
  name = "popup-common-settings",
  no_dim = true,
  no_follow_mouse = true,
  no_initial_focus = true,
  match = { tag = "popup" },
}

hl.window_rule {
  name = "awakened-poe-trade",
  float = true,
  no_dim = true,
  no_follow_mouse = true,
  no_initial_focus = true,
  match = { class = "^awakened-poe-trade$" },
}

hl.window_rule {
  name = "float-modal-windows",
  group = "deny",
  float = true,
  match = { modal = true },
}

hl.window_rule {
  name = "fix-gimp-windows",
  float = true,
  no_dim = true,
  no_follow_mouse = true,
  no_initial_focus = true,
  match = { class = "^gimp$" },
}

hl.window_rule {
  name = "float-sound-controls",
  group = "deny",
  float = true,
  match = { class = "^([Pp]avucontrol|com.github.wwmm.easyeffects)$" },
}

hl.window_rule {
  name = "pupgui",
  float = true,
  group = "deny",
  match = { class = "^net.davidotek.pupgui2$" },
}

hl.window_rule {
  name = "easyeffects",
  move = { "monitor_w-window_w-4", tostring(waybar_gap + 6) },
  size = { "monitor_w*0.5", "monitor_h*0.75" },
  match = { class = "^com.github.wwmm.easyeffects$" },
}

hl.window_rule {
  name = "telegram",
  focus_on_activate = true,
  tag = "+private",
  match = { class = "^org.telegram.desktop$" },
}

hl.window_rule {
  name = "zen",
  focus_on_activate = true,
  match = { class = "^zen$" },
}

hl.window_rule {
  name = "private-windows",
  tag = "+private",
  match = { class = "(^org.keepassxc.KeePassXC$|^com.github.hluk.copyq$)" },
}

hl.window_rule {
  name = "disable-screenshare-based-on-tag",
  no_screen_share = true,
  match = { tag = "private" },
}

hl.window_rule {
  name = "pavucontrol",
  move = { "monitor_w-window_w-4", tostring(waybar_gap + 6) },
  size = { "monitor_w*0.3", "monitor_h*0.42" },
  match = { class = "^[Pp]avucontrol$" },
}

hl.window_rule {
  name = "blueman-manager",
  float = true,
  group = "deny",
  move = { "monitor_w-window_w-28", tostring(waybar_gap + 6) }, -- weird bug, window size is bigger for some reason
  size = { "monitor_w*0.25", "monitor_h*0.325" },
  match = { class = "[Bb]lueman-manager" },
}

hl.window_rule {
  name = "proton-up",
  float = true,
  match = { title = "^ProtonUp-Qt.+" },
}

hl.window_rule {
  name = "protontricks",
  float = true,
  group = "deny",
  match = { title = "^Protontricks$" },
}

hl.window_rule {
  name = "xfce4-power-manager-settings",
  float = true,
  match = { class = "^Xfce4-power-manager-settings$" },
}

hl.window_rule {
  name = "network-manager",
  float = true,
  group = "deny",
  match = { class = "^nm-connection-editor$" },
}

hl.window_rule {
  name = "always-float",
  group = "deny",
  float = true,
  match = { class = "(Pcmanfm|Onboard|Yad)" },
}

hl.window_rule {
  name = "gearlever",
  float = true,
  group = "deny",
  match = { class = "^it.mijorus.gearlever$" },
}

hl.window_rule {
  name = "steam-main-window",
  float = true,
  match = { class = "^[Ss]team$", title = "negative:^([Ss]team|Список друзей|Friends List).*$" },
}

hl.window_rule {
  name = "ghostty-blur",
  match = { class = "^com\\.mitchellh\\.ghostty|ghostty\\.float$" },
  tag = "+blurry",
}

hl.window_rule {
  name = "kitty-blur",
  match = { class = "^kitty$" },
  tag = "+blurry",
}

hl.window_rule {
  name = "wezterm-blur",
  match = { class = "^org\\.wezfurlong\\.wezterm$" },
  tag = "+blurry",
}

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule {
  name = "ignore-maximize",
  render_unfocused = true,
  idle_inhibit = "fullscreen",
  no_dim = true,
  no_follow_mouse = true,
  match = { fullscreen = true },
}

hl.layer_rule {
  name = "swaync-control-center",
  blur = true,
  ignore_alpha = 0.1,
  no_screen_share = true,
  match = { namespace = "swaync-control-center" },
}

hl.layer_rule {
  name = "blur-waybar",
  blur = true,
  match = { namespace = "waybar" },
}

hl.layer_rule {
  name = "swaync-notification-center",
  blur = true,
  no_screen_share = true,
  ignore_alpha = 0.1,
  match = { namespace = "swaync-notification-window" },
}

-- Fix some dragging issues with XWayland
hl.window_rule {
  name = "windowrule-31",
  no_focus = true,
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
}

hl.window_rule {
  name = "windowrule-32",
  no_dim = true,
  no_follow_mouse = true,
  no_initial_focus = true,
  match = { pin = true },
}

-- Smart gaps
hl.workspace_rule { workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 }
hl.workspace_rule { workspace = "w[g]s[false]", gaps_out = 0, gaps_in = 0 }
hl.workspace_rule { workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 }

hl.window_rule {
  name = "smart-gaps-1",
  border_size = 0,
  rounding = 0,
  match = { float = false, workspace = "w[tv1]s[false]" },
}

hl.window_rule {
  name = "smart-gaps-2",
  border_size = 0,
  rounding = 0,
  match = { float = false, workspace = "f[1]s[false]" },
}

hl.window_rule {
  name = "single-window-on-workspace",
  no_blur = true,
  no_anim = true,
  no_shadow = true,
  rounding = 0,
  immediate = true,
  match = { workspace = "f[0]s[false]", tag = "negative:blurry" },
}

hl.window_rule {
  name = "steam-games",
  match = { class = "^steam_app_\\d+$" },
  fullscreen = true,
  workspace = "4",
}

hl.window_rule {
  name = "proton-games",
  match = { xdg_tag = "^proton-game$" },
  fullscreen = true,
  workspace = "4",
}

hl.window_rule {
  name = "content-games",
  match = { content = "3" },
  fullscreen = true,
  workspace = "4",
}

hl.window_rule {
  name = "xwaylandvideobridge",
  match = { class = "xwaylandvideobridge" },
  no_initial_focus = true,
  no_focus = true,
  no_anim = true,
  no_blur = true,
  max_size = { 1, 1 },
  opacity = "0.0",
}
