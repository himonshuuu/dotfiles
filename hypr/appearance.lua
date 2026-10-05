-- Appearance (stripped down)
hl.config({
    general = {
        gaps_in    = 5,
        gaps_out   = 10,
        border_size = 0,
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 14,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = { enabled = false },
        blur   = { enabled = false },
    },

    animations = { enabled = true },

    dwindle = { preserve_split = true },
    master  = { new_status = "master" },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})

-- Animations (similar to himonshuuu/dotfiles, minimal)
hl.curve("wind",   { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.05} } })
hl.curve("winIn",  { type = "bezier", points = { {0.1, 1.1},   {0.1, 1.1}   } })
hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3},  {0, 1}       } })
hl.curve("liner",  { type = "bezier", points = { {1, 1},       {1, 1}       } })

hl.animation({ leaf = "windows",     enabled = true, speed = 6,  bezier = "wind",   style = "slide"    })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 6,  bezier = "winIn",  style = "gnomed"   })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 5,  bezier = "winOut", style = "slide"    })
hl.animation({ leaf = "border",      enabled = true, speed = 1,  bezier = "liner"                        })
hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "default"                      })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "wind",   style = "slide"    })
