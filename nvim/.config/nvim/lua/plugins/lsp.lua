return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        -- 1. Setup Mason
        require("mason").setup()

        -- 2. Setup Mason-LSPConfig with the modern API
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",  -- Add any other servers you want here
                "pyright",       -- Python
                "clangd",        -- C / C++
                "jdtls",         -- Java
                "rust_analyzer", -- Rust
                "html",          -- HTML
                "cssls",         -- CSS
                "ts_ls",         -- JS / TS
            },
            automatic_enable = true, 
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- The special '*' target applies these settings to EVERY language server
        vim.lsp.config('*', {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                local opts = { buffer = bufnr }
                -- Press 'K' to see hover documentation (like function signatures)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                -- Press 'gd' to Go to Definition
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                -- Press '<leader>rn' to rename a variable across the whole file
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            end,
        })
    end,
}
