return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- 1. The 3D Block "APLÓS" Banner (Retained)
        dashboard.section.header.val = {
            [[ █████╗ ██████╗ ██╗      ██████╗ ███████╗]],
            [[██╔══██╗██╔══██╗██║     ██╔═══██╗██╔════╝]],
            [[███████║██████╔╝██║     ██║   ██║███████╗]],
            [[██╔══██║██╔═══╝ ██║     ██║   ██║╚════██║]],
            [[██║  ██║██║     ███████╗╚██████╔╝███████║]],
            [[╚═╝  ╚═╝╚═╝     ╚══════╝ ╚═════╝ ╚══════╝]],
            [[                                        ]],
            [[          ⚡ A Functional Simple Setup ⚡         ]],
        }

        -- 2. "Execution Script" Menu Style
        dashboard.section.buttons.val = {
            dashboard.button("f", "❯  Find File", ":Telescope find_files<CR>"),
            dashboard.button("r", "❯  Recent Files", ":Telescope oldfiles<CR>"),
            dashboard.button("n", "❯  New Buffer", ":ene <BAR> startinsert <CR>"),
            dashboard.button("l", "❯  Lazy Packages", ":Lazy<CR>"),
            dashboard.button("q", "❯  Quit Neovim", ":qa<CR>"),
        }

        -- 3. Hacker/Terminal Style Footer
        local function get_footer()
            local total_plugins = require("lazy").stats().count
            return "[ core online :: " .. total_plugins .. " modules loaded ]"
        end
        dashboard.section.footer.val = get_footer()

        -- 4. Minimalist Layout Adjustments
        -- We removed the hard-coded layout pipeline and went back to standard padding
        -- to give the 3D text room to breathe against the dark background.
        dashboard.section.header.opts.margin = 6
        dashboard.section.buttons.opts.spacing = 1

        -- 5. Dynamic Theme Colors
        -- Adjusted the links so the menu items pop with a crisp, functional color
        vim.api.nvim_set_hl(0, "AlphaHeader", { link = "Keyword" })    
        vim.api.nvim_set_hl(0, "AlphaButtons", { link = "Function" })  
        vim.api.nvim_set_hl(0, "AlphaShortcut", { link = "Number" })   
        vim.api.nvim_set_hl(0, "AlphaFooter", { link = "Comment" })

        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"

        -- 6. Clean Initialization
        alpha.setup(dashboard.opts)

        -- Auto-open dashboard if you wipe out all active workspace buffers
        vim.api.nvim_create_autocmd("BufDelete", {
            callback = function()
                local buffers = vim.fn.getbufinfo({ buflisted = 1 })
                if #buffers == 1 and buffers[1].name == "" and buffers[1].changed == 0 then
                    vim.cmd("Alpha")
                end
            end,
        })
    end,
}
