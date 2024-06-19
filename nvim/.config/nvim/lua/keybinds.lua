vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pp", "<CMD>:Neotree<CR>")
vim.keymap.set("n", "<leader>p[", "<CMD>:wincmd p<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
