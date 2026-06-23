--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Todo window rules
hl.window_rule({
    match = { title = "^(Minimal Todo)$" },
    float = true,
    size = "450 600",
    center = true,
    rounding = 0
})

-- YouTube / Picture-in-Picture window rule
hl.window_rule({
    name = "youtube-pip",
    match = { title = "^(Picture(-| )in(-| )[Pp]icture)$" },
    float = true,
    pin = true, -- Pins the window to all workspaces
    size = "25% 25%", -- Optional: adjust to your preferred size
    move = "100%-w-20 100%-h-20" -- Optional: moves to bottom right corner
})

-- =========================================
-- TRANSPARENCY / OPACITY RULES
-- =========================================

-- Make Kitty transparent
hl.window_rule({
    name  = "transparent-kitty",
    match = { class = "^(kitty)$" },
    opacity = "0.85 0.85", 
})

-- Make Todo app transparent
hl.window_rule({
    name  = "transparent-todo",
    match = { title = "^(Minimal Todo)$" },
    
    opacity = "0.85 0.85", 
})

-- Opening Animation for rofi
hl.layer_rule({
    name  = "rofi-animation",
    match = { namespace = "^(rofi)$" },
    -- Pick ONE animation style below:

    -- animation = "popin 85%", 
     animation = "slide",
    -- animation = "fade",
    blur = true,
})
