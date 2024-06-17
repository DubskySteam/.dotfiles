return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", "<cmd>Git status<CR>")
        vim.keymap.set("n", "<leader>gc", ":Git commit -m ");
        vim.keymap.set("n", "<leader>gp", "<cmd>:Git push<CR>");
        vim.keymap.set("n", "<leader>gd", "<cmd>:Git diff<CR>");
    end
}
