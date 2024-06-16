return {
    { "folke/lazy.nvim" },
    {
        'rebelot/kanagawa.nvim',
        config = function()
            vim.cmd("colorscheme kanagawa")
        end
    },
    {
        'nvim-lua/plenary.nvim'
    },
    {
        'nvim-telescope/telescope.nvim'
    },
}
