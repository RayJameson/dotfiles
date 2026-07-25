-- keybindings.lua
local K = require("keys")
local scripts = "~/.config/hypr/scripts"
local media = "~/.local/share/chezmoi/.assets"
local fileManager = "nautilus"
local webBrowser = "zen-browser"
local terminal = scripts .. "/ghostty"

---@param msg string
---@param opts? { urgency?: string, icon?: string }
local function notify(msg, opts)
  opts = opts or {}
  local urgency = opts.urgency or "low"
  local icon = opts.icon or media .. "/hyprland_logo.png"
  hl.exec_cmd("notify-send -u " .. urgency .. " -i " .. icon .. ' -h string:wayland-stack:hyprland "' .. msg .. '"')
end

-- See https://wiki.hyprland.org/Configuring/Keywords/

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
hl.bind(K.SUPER + K.Return, hl.dsp.exec_cmd(terminal))
hl.bind(K.SUPER + K.D, hl.dsp.exec_cmd(scripts .. "/toggle_screenshare 1"))
hl.bind(K.SUPER + K.V, hl.dsp.exec_cmd(scripts .. "/copyq.sh"))
hl.bind(
  K.SUPER + K.SHIFT + K.Return,
  hl.dsp.exec_cmd("[float; group deny; center; size (monitor_w*0.75) (monitor_h*0.75);] " .. terminal .. " --float")
)
hl.bind(K.SUPER + K.Q, hl.dsp.window.close())
hl.bind(K.SUPER + "mouse:274", hl.dsp.window.close())
hl.bind(K.SUPER + K.SHIFT + K.Q, hl.dsp.exec_cmd("hyprctl activewindow | grep -oP '(?<=pid: )\\d+' | xargs kill -15"))
hl.bind(
  K.SUPER + K.SHIFT + K.CTRL + K.Q,
  hl.dsp.exec_cmd("hyprctl activewindow | grep -oP '(?<=pid: )\\d+' | xargs kill -9")
)
hl.bind(K.SUPER + K.T, hl.dsp.window.float { action = "toggle" })
hl.bind(K.SUPER + K.SHIFT + K.G, hl.dsp.group.toggle())
hl.bind(K.SUPER + K.SHIFT + K.O, function()
  hl.dispatch(hl.dsp.window.pin())
  notify("Toggle window pin")
end)
hl.bind(K.SUPER + K.F, hl.dsp.window.fullscreen { mode = "fullscreen" })
hl.bind(K.SUPER + K.SHIFT + K.P, function()
  hl.dispatch(hl.dsp.window.pseudo())
  notify("Toggle pseudo tiling")
end)
hl.bind(K.SUPER + K.SHIFT + K.S, hl.dsp.exec_cmd(scripts .. "/toggle_swallow.sh"))
hl.bind(K.SUPER + K.SHIFT + K.R, function()
  hl.exec_cmd("hyprctl reload")
  hl.exec_cmd("rm -f ~/.cache/rofi-drun-desktop.cache")
  notify("Config reloaded")
end)

hl.bind(K.SUPER + K.P, hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(K.CTRL + K.SPACE, hl.dsp.exec_cmd(scripts .. "/rofi_launcher"))
hl.bind(K.SUPER + K.N, hl.dsp.exec_cmd(scripts .. "/network_menu"))
hl.bind(K.SUPER + K.M, hl.dsp.exec_cmd("missioncenter"))
hl.bind(K.SUPER + K.SHIFT + K.N, hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(K.SUPER + K.Z, hl.dsp.exec_cmd(scripts .. "/rofi_powermenu"))
hl.bind(K.SUPER + K.W, hl.dsp.exec_cmd(scripts .. "/rofi_windows"))
hl.bind(K.SUPER + K.A, hl.dsp.exec_cmd(scripts .. "/rofi_ghostty_windows"))
hl.bind(K.SUPER + K.S, hl.dsp.exec_cmd(scripts .. "/rofi_screenshot"))
hl.bind(K.SUPER + K.SHIFT + K.L, hl.dsp.exec_cmd("hyprlock"))

hl.bind(K.CTRL + K.ALT + K.F, hl.dsp.exec_cmd(fileManager))
hl.bind(K.CTRL + K.ALT + K.W, hl.dsp.exec_cmd(webBrowser))

-- Move focus with mod + hjkl
hl.bind(K.SUPER + K.H, hl.dsp.focus { direction = "left" })
hl.bind(K.SUPER + K.L, hl.dsp.focus { direction = "right" })
hl.bind(K.SUPER + K.K, hl.dsp.focus { direction = "up" })
hl.bind(K.SUPER + K.J, hl.dsp.focus { direction = "down" })

-- Cycle windows in current workspace
hl.bind(K.SUPER + K.Tab, hl.dsp.window.cycle_next())
hl.bind(K.SUPER + K.SHIFT + K.Tab, hl.dsp.window.cycle_next { next = false })

-- Move windows with mod + CTRL + hjkl
hl.bind(K.SUPER + K.CTRL + K.H, hl.dsp.window.move { direction = "left", group_aware = true })
hl.bind(K.SUPER + K.CTRL + K.L, hl.dsp.window.move { direction = "right", group_aware = true })
hl.bind(K.SUPER + K.CTRL + K.K, hl.dsp.window.move { direction = "up", group_aware = true })
hl.bind(K.SUPER + K.CTRL + K.J, hl.dsp.window.move { direction = "down", group_aware = true })

-- Move window in the group
hl.bind(K.SHIFT + K.CTRL + K.left, hl.dsp.group.move_window { forward = false })
hl.bind(K.SHIFT + K.CTRL + K.right, hl.dsp.group.move_window())

-- Switch workspaces with mod + [0-9]
for i = 1, 10 do
  local key = i % 10
  hl.bind(K.SUPER + key, hl.dsp.focus { workspace = i })
end
hl.bind(K.SUPER + K.left, hl.dsp.focus { workspace = "e-1" })
hl.bind(K.SUPER + K.right, hl.dsp.focus { workspace = "e+1" })
hl.bind(K.SUPER + K.B, hl.dsp.focus { workspace = "previous" })

-- Move active window to a workspace with mod + CTRL + [0-9]
for i = 1, 10 do
  local key = i % 10
  hl.bind(K.SUPER + K.CTRL + key, hl.dsp.window.move { workspace = i })
end
hl.bind(K.SUPER + K.CTRL + K.left, hl.dsp.exec_cmd(scripts .. "/switch_workspace +1 -mj"))
hl.bind(K.SUPER + K.CTRL + K.right, hl.dsp.exec_cmd(scripts .. "/switch_workspace -1 -mj"))
hl.bind(K.SUPER + K.CTRL + K.mouse_down, hl.dsp.exec_cmd(scripts .. "/switch_workspace -1 -mj"))
hl.bind(K.SUPER + K.CTRL + K.mouse_up, hl.dsp.exec_cmd(scripts .. "/switch_workspace +1 -mj"))
hl.bind(K.SUPER + K.CTRL + K.B, hl.dsp.window.move { workspace = "previous" })
hl.bind(K.SUPER + K.CTRL + K.n, hl.dsp.window.move { workspace = "emptym" })

-- Special workspace (scratchpad)
hl.bind(K.SUPER + K.minus, hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(K.SUPER + K.equal, hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(K.SUPER + K.CTRL + K.minus, hl.dsp.window.move { workspace = "special:scratchpad", follow = false })
hl.bind(K.SUPER + K.CTRL + K.equal, hl.dsp.window.move { workspace = "special:scratchpad", follow = false })

-- Scroll through existing workspaces with mod + scroll
hl.bind(K.SUPER + K.mouse_down, hl.dsp.focus { workspace = "e-1" })
hl.bind(K.SUPER + K.mouse_up, hl.dsp.focus { workspace = "e+1" })

-- Move/resize windows with mod + LMB/RMB and dragging
hl.bind(K.SUPER + "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(K.SUPER + "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize mode
hl.bind(K.SUPER + K.ALT + K.R, hl.dsp.submap("resize"))

hl.define_submap("resize", function()
  hl.bind(K.l, hl.dsp.window.resize { x = 10, y = 0, relative = true }, { repeating = true })
  hl.bind(K.h, hl.dsp.window.resize { x = -10, y = 0, relative = true }, { repeating = true })
  hl.bind(K.k, hl.dsp.window.resize { x = 0, y = -10, relative = true }, { repeating = true })
  hl.bind(K.j, hl.dsp.window.resize { x = 0, y = 10, relative = true }, { repeating = true })
  hl.bind(K.Escape, hl.dsp.submap("reset"))
end)

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
  K.XF86AudioRaiseVolume,
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { repeating = true, locked = true }
)
hl.bind(
  K.XF86AudioLowerVolume,
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { repeating = true, locked = true }
)
hl.bind(
  K.XF86AudioMute,
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { repeating = true, locked = true }
)
hl.bind(
  K.XF86AudioMicMute,
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { repeating = true, locked = true }
)
hl.bind(K.XF86MonBrightnessUp, hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true, locked = true })
hl.bind(K.XF86MonBrightnessDown, hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true, locked = true })

-- Requires playerctl
hl.bind(K.XF86AudioNext, hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind(K.XF86AudioPause, hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(K.XF86AudioStop, hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind(K.XF86AudioPlay, hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(K.XF86AudioPrev, hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(
  K.SUPER + K.SHIFT + K.mouse_down,
  hl.dsp.exec_cmd(
    "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.2}')"
  )
)
hl.bind(
  K.SUPER + K.SHIFT + K.mouse_up,
  hl.dsp.exec_cmd(
    "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 0.8}')"
  )
)

hl.bind(K.SUPER + K.SHIFT + "mouse:274", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor 1"))
hl.bind(K.SUPER + K.SHIFT + "0", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor 1"))
