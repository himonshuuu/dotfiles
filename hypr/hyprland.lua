-- Hyprland configuration (modular)

require("programs")
require("monitors")
require("appearance")
require("input")
require("keybinds")
require("autostart")
require("windowrules")

-- Environment / theme (system-wide GTK settings are in /etc/gtk-3.0 and /etc/gtk-4.0)
hl.env("XCURSOR_THEME", "Bibata-Modern-Amber")
hl.env("XCURSOR_SIZE", "12")
hl.env("HYPRCURSOR_SIZE", "12")
