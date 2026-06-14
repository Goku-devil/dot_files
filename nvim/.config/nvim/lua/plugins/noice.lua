return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        -- 1. Configure the notification engine for a minimalist aesthetic
        require("notify").setup({
            background_colour = "#000000", -- Keeps the background pitch black to blend in
            stages = "fade",               -- Replaces bouncy slides with a clean fade
            render = "minimal",            -- Strips thick borders, title bars, and giant icons
            timeout = 5000,                -- Disappears quickly (2 seconds)
            max_width = 45,                -- Keeps the text block narrow and tight
            top_down = false,              -- Spawns them in the bottom-right corner
        })

        -- 2. Initialize Noice with your custom UI and new routing rules
        require("noice").setup({
            cmdline = {
                enabled = true,
                view = "cmdline_popup",
                format = {
                    cmdline = { pattern = "^:", icon = "❯", lang = "vim", opts = { border = { text = { top = " Command ", top_align = "center" } } } },
                    search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex", opts = { border = { text = { top = " Search Down ", top_align = "center" } } } },
                    search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex", opts = { border = { text = { top = " Search Up ", top_align = "center" } } } },
                    filter = { pattern = "^:%s*!", icon = "⚡", lang = "bash", opts = { border = { text = { top = " Shell ", top_align = "center" } } } },
                    lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua", opts = { border = { text = { top = " Lua ", top_align = "center" } } } },
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = "30%", 
                        col = "50%",
                    },
                    size = {
                        width = 50, 
                        height = "auto",
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 2 }, 
                    },
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                        winblend = 0, 
                        cursorline = false,
                    },
                },
                mini = {
                    win_options = { winblend = 0 },
                },
            },
            routes = {
                -- SILENCE: Completely hide "written" (save) messages so they do not flash on screen
                { filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
                
                -- ROUTE TO MINI: Send minor UI messages to the tiny bottom line
                { filter = { event = "msg_show" }, view = "mini" },
                
                -- ALLOW POPUPS: Show actual plugin notifications and errors as floating popups
                { filter = { error = true }, view = "notify" },
                { filter = { event = "notify" }, view = "notify" },
            },
            presets = {
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = true,
            },
            notify = { enabled = true }, -- Re-enables the core notification engine
        })
    end
}
