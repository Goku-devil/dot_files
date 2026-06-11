return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Adds file icons
    config = function()
        require("lualine").setup({
            options = {
                -- 'auto' tells lualine to match your current colorscheme 
                -- (catppuccin, tokyonight, etc.)
                theme = "auto", 
                
                -- Custom separators (requires a Nerd Font installed on your system)
                component_separators = { left = '|', right = '|'},
                section_separators = { left = '', right = ''},
                
                globalstatus = true, -- Use a single statusline for all splits
            },
            sections = {
                lualine_a = { 'mode' }, -- Shows NORMAL, INSERT, VISUAL
                lualine_b = { 'branch', 'diff', 'diagnostics' }, -- Git info & errors (E, W, H)
                lualine_c = { 
                    {
                        'filename',
                        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                    }
                },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' }, -- Scroll percentage
                lualine_z = { 'location' }  -- Line and column number
            },
        })
    end,
}
