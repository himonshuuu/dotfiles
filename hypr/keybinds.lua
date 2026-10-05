-- Keybinds
local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
-- App launcher lives in Quickshell (components/launcher/Launcher.qml)
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("qs ipc call launcher toggle"))
-- Power menu (Quickshell) - lock / log out / restart / shut down
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("qs ipc call powermenu toggle"))
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
-- Tag the focused window as "private" (hidden from screen share, see windowrules.lua)
hl.bind(mainMod .. " + G", function()
    local function hasTag(tags)
        if tags == nil then return false end
        if type(tags) == "string" then return tags:find("private") ~= nil end
        if type(tags) == "table" then
            for _, t in ipairs(tags) do if t == "private" then return true end end
        end
        return false
    end
    local w = hl.get_active_window()
    local had = hasTag(w and w.tags)
    hl.dispatch(hl.dsp.window.tag({ tag = "private" }))
    local state = had and "DISABLED" or "ENABLED"
    local cls = (w and w.class) or "unknown"
    hl.exec_cmd('notify-send -i "' .. cls .. '" "Hyprland" "Privacy ' .. state .. ': ' .. cls .. '"')
end)
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Focus with arrows
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Screenshot: area select
-- Region screenshot (Quickshell): drag the box, it saves to
-- ~/Pictures/Screenshots and copies the PNG to the clipboard
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("qs ipc call screenshot pick"))

-- Random wallpaper
-- Next wallpaper: Quickshell lists the folder and cross-fades the new image
-- in itself (services/wallpaper/Wallpaper.qml), so no awww/find/shuf needed
hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd("qs ipc call wallpaper random"))

-- Notification viewer (Quickshell side panel)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("qs ipc call notifviewer toggle"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),               { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),               { locked = true, repeating = true })
