-------------------
---- AUTOSTART ----
-------------------

local state_file = os.getenv("HOME") .. "/.config/hypr/.theme_state"
local function get_current_theme()
    local f = io.open(state_file, "r")
    if f then
        local theme = f:read("*l")
        f:close()
        if theme and theme ~= "" then
            return theme
        end
    end
    return "nord"
end


hl.on("hyprland.start", function () 
    os.execute("~/.config/hypr/scripts/apply_theme.sh " .. get_current_theme())
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --type text --watch cliphist store &")
    hl.exec_cmd("wl-paste --type image --watch cliphist store &")
    hl.exec_cmd("wl-clip-persist --clipboard regular &") 
 end)
