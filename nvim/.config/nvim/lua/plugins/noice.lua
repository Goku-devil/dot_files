return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            cmdline = {
                enabled = true,
                view = "cmdline_popup",
                format = {
                    -- Dynamically injects the mode title framed cleanly inside the top rounded border
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
                        style = "rounded",  -- Smooth Unicode corners (╭ ╮ ╰ ╯)
                        padding = { 0, 2 }, 
                    },
                    win_options = {
                        -- Uses the theme's solid floating background to block out text from underlying buffers
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                        winblend = 0, -- 100% opaque to fix character-overlap soups
                        cursorline = false,
                    },
                },
                mini = {
                    win_options = { winblend = 0 },
                },
            },
            routes = {
                -- Redirects annoying errors, messages, and standard notifications down to the mini statusline view
                { filter = { event = "msg_show" }, view = "mini" },
                { filter = { error = true }, view = "mini" },
                { filter = { event = "notify" }, view = "mini" },
            },
            presets = {
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = true,
            },
            notify = { enabled = false }, -- Mutes massive toast notifications for maximum visual minimalism
        })
    end
}
