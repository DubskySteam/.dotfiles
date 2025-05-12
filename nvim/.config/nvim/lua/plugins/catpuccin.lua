return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        integrations = { blink_cmp = true },
    },
    config = function()
        vim.cmd("colorscheme catppuccin")
    end
}