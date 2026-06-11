vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set('n', '<C-s>', '<cmd>update<cr>', { silent = true })
vim.keymap.set('i', '<C-s>', '<C-o><cmd>update<cr>', { silent = true })
vim.keymap.set('v', '<C-s>', '<cmd>update<cr>', { silent = true })
