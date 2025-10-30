-- lua/user/core/keymaps.lua

vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness

-- General Keymaps
keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save buffer" })

-- Add this to your keymaps.lua
keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
-- Add this to lua/user/core/keymaps.lua
keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
-- from lua/user/core/keymaps.lua
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Clear search highlighting
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Split navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize splits
keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase window height" })
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

