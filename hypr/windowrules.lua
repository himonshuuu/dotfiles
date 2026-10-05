-- Privacy / screen-share rules

-- Windows tagged "private" (bind SUPER+G) are hidden from screen sharing
hl.window_rule({
    name  = "private-no-screenshare",
    match = { tag = "private" },
    no_screen_share = true,
})

-- Discord DMs are hidden from screen sharing
hl.window_rule({
    name  = "discord-no-screenshare",
    match = { title = "^@.* - Discord$" },
    no_screen_share = true,
})

-- WhatsApp Web is hidden from screen sharing
hl.window_rule({
    name  = "whatsapp-no-screenshare",
    match = { title = "^.*WhatsApp.*$" },
    no_screen_share = true,
})

-- Kitty terminal opens as a floating centered 700x500 window
hl.window_rule({
    name  = "kitty-floater",
    match = { initial_class = "^kitty$" },
    float = true,
    center = true,
    size  = { 700, 500 },
    suppress_event = "maximize",
})
