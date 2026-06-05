require("modules.keybinds")
require("modules.monitors")
require("modules.autostart")
require("modules.theme")
require("modules.env")
require("modules.animation")
require("modules.input")
require("modules.window")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})

-- Ensure Lua can find your themes folder
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypr/?.lua"

-- 1. Read the current theme from the state file
local state_file = os.getenv("HOME") .. "/.config/hypr/.theme_state"
local function get_current_theme()
    local f = io.open(state_file, "r")
    if f then
        local theme = f:read("*l")
        f:close()
        if theme and theme ~= "" then return theme end
    end
    return "catppuccin" -- Default fallback
end

local theme_name = get_current_theme()
local palette = require("themes." .. theme_name)

-- 2. Apply borders using the CORRECT Native Lua table syntax
hl.config({
    general = {
        col = {
            active_border = { colors = { palette.active1, palette.active2 }, angle = 45 },
            inactive_border = { colors = { palette.inactive } }
        }
    }
})

-- 3. Keybinds to trigger the Bash engine
local themes = { "catppuccin", "evergreen", "tokyonight" }
local function get_next_theme(current)
    for i, v in ipairs(themes) do
        if v == current then
            local next_idx = i + 1
            if next_idx > #themes then next_idx = 1 end
            return themes[next_idx]
        end
    end
    return themes[1]
end

hl.bind("SUPER + T", function()
    local next_t = get_next_theme(theme_name)
    os.execute("~/.config/hypr/scripts/apply_theme.sh " .. next_t .. " &")
end)

hl.bind("SUPER + SHIFT + T", function()
    os.execute("~/.config/rofi/scripts/theme_switcher.sh &")
end)