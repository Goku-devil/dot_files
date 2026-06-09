require('config.options')
require('config.keybinds')
require('config.lazy')
require('plugins.colours')

-- ==============================================================================
-- DYNAMIC THEME ENGINE
-- ==============================================================================
local function load_dynamic_theme()
    -- 1. Read the theme state file
    local theme_path = vim.fn.stdpath("config") .. "/theme.txt"
    local file = io.open(theme_path, "r")
    local theme_state = "catppuccin" -- fallback default

    if file then
        theme_state = file:read("*l")
        file:close()
    end

    -- 2. Map your Bash theme names to Neovim plugin names
    local theme_map = {
        ["catppuccin"] = "catppuccin",
        ["evergreen"]  = "everforest",
        ["tokyonight"] = "tokyonight",
        ["rosepine"]   = "rose-pine",
        ["nord"]       = "nord"
    }

    -- 3. Get the correct nvim theme name, default to catppuccin if not found
    local nvim_theme = theme_map[theme_state] or "catppuccin"

    -- 4. Safely apply the colorscheme
    local status_ok, _ = pcall(vim.cmd.colorscheme, nvim_theme)
    if not status_ok then
        vim.notify("Theme engine failed to load: " .. nvim_theme, vim.log.levels.WARN)
    end
end

load_dynamic_theme()
