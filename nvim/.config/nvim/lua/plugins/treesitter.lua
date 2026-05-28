return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- THIS IS THE MAGIC FIX
  build = ":TSUpdate",
  
  event = { "VeryLazy" },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },

  main = "nvim-treesitter.configs",

  opts = {
    highlight = { 
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "vim",
      "vimdoc",
      "yaml",
    },
    sync_install = false,
    auto_install = true,
  },
}
