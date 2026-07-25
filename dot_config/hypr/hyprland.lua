-- hyprland.lua
require("environment")
require("keybindings")
require("rules")

------------------
--- AUTOSTART
------------------
local function start_waybar() hl.exec_cmd("killall waybar -q; waybar") end

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
hl.exec_cmd("killall waybar -q; waybar")
hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  start_waybar()
  hl.exec_cmd("hyprctl setcursor elementary 24")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("uxplay -vs 0 -async -p -reset 0 -nh -n 'Archcraft audio'")
  hl.exec_cmd("sleep 5 && easyeffects --gapplication-service")
  hl.exec_cmd("sleep 5 && systemctl --user start hyprland-session.target")
end)
hl.on("hyprland.shutdown", function() hl.exec_cmd("systemctl --user stop hyprland-session.target") end)
hl.on("config.reloaded", function() start_waybar() end)

--------------
--- MONITORS
--------------

-- See https://wiki.hyprland.org/Configuring/Monitors/
hl.monitor { output = "", mode = "preferred", position = "auto", scale = "auto" }

---------------------
--- LOOK AND FEEL
---------------------

-- Refer to https://wiki.hyprland.org/Configuring/Variables/

-- https://wiki.hyprland.org/Configuring/Variables/#general
hl.config {
  general = {
    gaps_in = 2,
    gaps_out = 4,
    border_size = 0,
    -- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },
    -- Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,
    -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = true,
    layout = "dwindle",
    snap = {
      enabled = true,
      respect_gaps = true,
      window_gap = 25,
      monitor_gap = 10,
    },
  },
}

-- https://wiki.hyprland.org/Configuring/Variables/#decoration
hl.config {
  decoration = {
    rounding = 10,
    rounding_power = 2,
    dim_inactive = true,
    dim_special = 0.5,
    dim_strength = 0.3,
    shadow = { enabled = false },
    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    -- https://wiki.hyprland.org/Configuring/Variables/#blur
    blur = {
      enabled = true,
      size = 2,
      passes = 3,
      special = true,
      vibrancy = 0.1696,
    },
  },
}

-- https://wiki.hyprland.org/Configuring/Variables/#animations
hl.config { animations = { enabled = true } }

-- Curves (were inside animations{} block)
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations
hl.animation { leaf = "global", enabled = true, speed = 10, bezier = "default" }
hl.animation { leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" }
hl.animation { leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" }
hl.animation { leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" }
hl.animation { leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" }
hl.animation { leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" }
hl.animation { leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" }
hl.animation { leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" }
hl.animation { leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" }
hl.animation { leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" }
hl.animation { leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" }
hl.animation { leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" }
hl.animation { leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" }
hl.animation { leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }

-- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
hl.config {
  dwindle = {
    force_split = 2,
  },
}

-- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
hl.config {
  master = {
    new_status = "slave",
    orientation = "right",
  },
}

-- https://wiki.hyprland.org/Configuring/Variables/#misc
hl.config {
  misc = {
    force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    disable_splash_rendering = true,
    enable_swallow = false,
    swallow_regex = "^.*ghostty.*$",
    focus_on_activate = false,
  },
}

hl.config {
  xwayland = {
    force_zero_scaling = true,
  },
}

hl.config {
  render = {
    direct_scanout = 2,
  },
}

---------------
--- INPUT
---------------

-- https://wiki.hyprland.org/Configuring/Variables/#input
hl.config {
  input = {
    kb_layout = "us,ru",
    kb_variant = "",
    kb_model = "",
    kb_options = "grp:win_space_toggle",
    kb_rules = "",
    follow_mouse = 1,
    accel_profile = "flat",
    repeat_delay = 200,
    repeat_rate = 30,
    touchpad = {
      natural_scroll = false,
    },
  },
}

-- Example per-device config
-- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
hl.device { name = "logitech-g102-prodigy-gaming-mouse", sensitivity = 1 }

hl.config {
  cursor = {
    zoom_disable_aa = true,
  },
}

hl.config {
  group = {
    insert_after_current = false,
    groupbar = {
      gradients = true,
      col = {
        active = "rgb(b874e8)",
        inactive = "rgba(b874e880)",
      },
      gradient_rounding = 0,
      rounding = 0,
      text_color = "rgb(1e1e2e)",
      scrolling = false,
      keep_upper_gap = false,
      font_size = 14,
      gaps_in = 0,
      gaps_out = 0,
    },
  },
}

-------------------
--- KEYBINDINGS
-------------------
hl.config {
  binds = {
    workspace_back_and_forth = true,
    allow_workspace_cycles = true,
    movefocus_cycles_groupfirst = true,
    scroll_event_delay = 0,
  },
}

hl.config {
  ecosystem = {
    enforce_permissions = true,
    no_update_news = true,
    no_donation_nag = true, -- i'm already subscribed to ko-fi
  },
}

hl.permission { binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" }
hl.permission { binary = "/usr/bin/hyprland-preview-share-picker", type = "screencopy", mode = "allow" }
hl.permission { binary = "/usr/bin/vesktop", type = "screencopy", mode = "allow" }
hl.permission { binary = "/usr/bin/flameshot", type = "screencopy", mode = "allow" }
hl.permission { binary = "/usr/bin/obs", type = "screencopy", mode = "allow" }
hl.permission { binary = "/usr/bin/grim", type = "screencopy", mode = "allow" }
hl.permission { binary = "/usr/bin/hyprpicker", type = "screencopy", mode = "allow" }
hl.permission { binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" }
