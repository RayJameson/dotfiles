-- environment.lua
-- ENVIRONMENT VARIABLES

-- See https://wiki.hyprland.org/Configuring/Environment-variables/

hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("GSK_RENDERER", "gl")
hl.env("GTK_THEME", "")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("WLR_BACKEND", "vulkan")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("HYPRCURSOR_THEME", "elementary")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "elementary")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__GL_SHADER_DISK_CACHE", "1")
hl.env("__GL_SHADER_DISK_CACHE_SKIP_CLEANUP", "1")
hl.env("__GL_SHADER_DISK_CACHE_SIZE", "12000000000")
hl.env("PROTON_DLSS_UPGRADE", "1")
