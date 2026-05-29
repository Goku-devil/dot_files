return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",     
        "hrsh7th/cmp-buffer",       
        "hrsh7th/cmp-path",         
        "L3MON4D3/LuaSnip",         
        "saadparwaiz1/cmp_luasnip", 
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        -- Dim the right-side text to a grey, italic comment color
        vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#5C6370", italic = true })

        -- A foolproof dictionary of exact VS Code icons
        local kind_icons = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰊄",
        }

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            
            formatting = {
                fields = { "kind", "abbr", "menu" }, 
                format = function(entry, vim_item)
                    -- 1. Store the original word (e.g., "Function", "Text")
                    local kind_text = vim_item.kind
                    
                    -- 2. Force the left column to be ONLY the icon from our dictionary
                    vim_item.kind = string.format("%s", kind_icons[kind_text] or "")
                    
                    -- 3. Push the original word to the far-right menu column
                    vim_item.menu = "   " .. kind_text
                    
                    return vim_item
                end,
            },

            window = {
                completion = {
                    border = "single", 
                    winblend = 0,
                },
                documentation = {
                    border = "single",
                    winblend = 0,
                },
            },
            
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(), 
                ["<C-j>"] = cmp.mapping.select_next_item(), 
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),    
                ["<C-f>"] = cmp.mapping.scroll_docs(4),     
                ["<C-Space>"] = cmp.mapping.complete(),     
                ["<C-e>"] = cmp.mapping.abort(),            
                ["<CR>"] = cmp.mapping.confirm({ select = true }), 
            }),
            
            sources = cmp.config.sources({
                { name = "nvim_lsp" }, 
                { name = "luasnip" },  
                { name = "buffer" },   
                { name = "path" },     
            }),
        })

        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}
