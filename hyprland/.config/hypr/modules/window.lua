--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
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

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
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
    rounding = 0 -- Adjust this number for more/less curve
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
    
    -- Format is: "active_opacity inactive_opacity"
    -- 0.85 is a great sweet spot for readability + blur
    opacity = "0.85 0.85", 
})

-- Make your Todo app transparent
hl.window_rule({
    name  = "transparent-todo",
    match = { title = "^(Minimal Todo)$" },
    
    opacity = "0.85 0.85", 
})
