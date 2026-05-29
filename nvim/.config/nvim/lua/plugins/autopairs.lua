return {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- Only load the plugin when you start typing
    config = function()
        require("nvim-autopairs").setup({
            check_ts = true, -- Enable treesitter integration (since you have treesitter installed)
            map_cr = true,   -- Map the <CR> (Enter) key
        })
    end,
}
