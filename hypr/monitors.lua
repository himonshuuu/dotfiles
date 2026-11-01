-- Monitors
-- Laptop panel
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 1,
})

-- BenQ MS560: native resolution is SVGA 800x600 (4:3).
-- 1920x1080 is accepted but downscaled by the projector, so use native.
-- At 1920x1080 the HDMI-to-VGA link also dropped the green channel
-- (white looked purple, green looked black); 800x600 is stable.
-- (If the HDMI-to-VGA adapter is still in use, it reports a fake EDID with
-- a 1024x768 preferred mode, so the mode must be set explicitly.)
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "800x600@60",
    position = "1920x0",
    scale    = 1,
})
