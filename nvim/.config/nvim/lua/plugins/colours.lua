return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Load this before all other plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true,
        term_colors = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
        },
      })

      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
      "nvim-lualine/lualine.nvim",
      dependencies = {
	"nvim-tree/nvim-web-devicons",
      },
      opts = {
	  theme = 'catppuccin',
      }
  }
}

