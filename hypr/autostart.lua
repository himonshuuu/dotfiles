-- Autostart (add your own daemons/apps here)
hl.on("hyprland.start", function()
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh")
    -- notifications + wallpaper are quickshell components, no daemon here
    hl.exec_cmd("quickshell")
end)
