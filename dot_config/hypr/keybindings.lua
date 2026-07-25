-- keybindings.lua
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
    hl.exec_cmd('notify-send -u ' .. urgency .. ' -i ' .. icon .. ' -h string:wayland-stack:hyprland "' .. msg .. '"')
end

-- See https://wiki.hyprland.org/Configuring/Keywords/
local mod = "SUPER" -- Sets "Windows" key as main modifier
local modShift = mod .. " + SHIFT"
local modCtrl = mod .. " + CTRL"
local CtrlAlt = "CTRL + ALT"

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(scripts .. "/toggle_screenshare 1"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd(scripts .. "/copyq.sh"))
hl.bind(modShift .. " + Return", hl.dsp.exec_cmd("[float; group deny; center; size (monitor_w*0.75) (monitor_h*0.75);] " .. terminal .. " --float"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + mouse:274", hl.dsp.window.close())
hl.bind(modShift .. " + Q", hl.dsp.exec_cmd('hyprctl activewindow | grep -oP \'(?<=pid: )\\d+\' | xargs kill -15'))
hl.bind(mod .. " + SHIFT + CTRL + Q", hl.dsp.exec_cmd('hyprctl activewindow | grep -oP \'(?<=pid: )\\d+\' | xargs kill -9'))
hl.bind(mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(modShift .. " + G", hl.dsp.group.toggle())
hl.bind(modShift .. " + O", function()
    hl.dispatch(hl.dsp.window.pin())
    notify("Toggle window pin")
end)
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(modShift .. " + P", function()
    hl.dispatch(hl.dsp.window.pseudo())
    notify("Toggle pseudo tiling")
end)
hl.bind(modShift .. " + S", hl.dsp.exec_cmd(scripts .. "/toggle_swallow.sh"))
hl.bind(modShift .. " + R", function()
    hl.exec_cmd("hyprctl reload")
    hl.exec_cmd("rm -f ~/.cache/rofi-drun-desktop.cache")
    notify("Config reloaded")
end)

hl.bind(mod .. " + P", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("CTRL + SPACE", hl.dsp.exec_cmd(scripts .. "/rofi_launcher"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd(scripts .. "/network_menu"))
hl.bind(mod .. " + M", hl.dsp.exec_cmd("missioncenter"))
hl.bind(modShift .. " + N", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mod .. " + Z", hl.dsp.exec_cmd(scripts .. "/rofi_powermenu"))
hl.bind(mod .. " + W", hl.dsp.exec_cmd(scripts .. "/rofi_windows"))
hl.bind(mod .. " + A", hl.dsp.exec_cmd(scripts .. "/rofi_ghostty_windows"))
hl.bind(mod .. " + S", hl.dsp.exec_cmd(scripts .. "/rofi_screenshot"))
hl.bind(modShift .. " + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(CtrlAlt .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(CtrlAlt .. " + W", hl.dsp.exec_cmd(webBrowser))


-- Move focus with mod + hjkl
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Cycle windows in current workspace
hl.bind(mod .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(modShift .. " + Tab", hl.dsp.window.cycle_next({ next = false }))

-- Move windows with mod + CTRL + hjkl
hl.bind(modCtrl .. " + H", hl.dsp.window.move({ direction = "left", group_aware = true }))
hl.bind(modCtrl .. " + L", hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind(modCtrl .. " + K", hl.dsp.window.move({ direction = "up", group_aware = true }))
hl.bind(modCtrl .. " + J", hl.dsp.window.move({ direction = "down", group_aware = true }))

-- Move window in the group
hl.bind("SHIFT + CTRL + left", hl.dsp.group.move_window({ forward = false }))
hl.bind("SHIFT + CTRL + right", hl.dsp.group.move_window())

-- Switch workspaces with mod + [0-9]
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
end
hl.bind(mod .. " + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + B", hl.dsp.focus({ workspace = "previous" }))

-- Move active window to a workspace with mod + CTRL + [0-9]
for i = 1, 10 do
    local key = i % 10
    hl.bind(modCtrl .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(modCtrl .. " + left", hl.dsp.exec_cmd(scripts .. "/switch_workspace +1 -mj"))
hl.bind(modCtrl .. " + right", hl.dsp.exec_cmd(scripts .. "/switch_workspace -1 -mj"))
hl.bind(modCtrl .. " + mouse_down", hl.dsp.exec_cmd(scripts .. "/switch_workspace -1 -mj"))
hl.bind(modCtrl .. " + mouse_up", hl.dsp.exec_cmd(scripts .. "/switch_workspace +1 -mj"))
hl.bind(modCtrl .. " + B", hl.dsp.window.move({ workspace = "previous" }))
hl.bind(modCtrl .. " + n", hl.dsp.window.move({ workspace = "emptym" }))

-- Special workspace (scratchpad)
hl.bind(mod .. " + minus", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mod .. " + equal", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(modCtrl .. " + minus", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
hl.bind(modCtrl .. " + equal", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Scroll through existing workspaces with mod + scroll
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

-- Move/resize windows with mod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize mode
hl.bind(mod .. " + ALT + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { repeating = true, locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true, locked = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(modShift .. " + mouse_down", hl.dsp.exec_cmd('hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk \'/^float.*/ {print $2 * 1.2}\')'))
hl.bind(modShift .. " + mouse_up", hl.dsp.exec_cmd('hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk \'/^float.*/ {print $2 * 0.8}\')'))

hl.bind(modShift .. " + mouse:274", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor 1"))
hl.bind(modShift .. " + 0", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor 1"))
