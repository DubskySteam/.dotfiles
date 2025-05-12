return {
        'nvimdev/dashboard-nvim',
        dependencies = { {'nvim-tree/nvim-web-devicons'}},
        event = "VimEnter",
        config = function()
            require('dashboard').setup{
                theme = 'doom',
                shortcut_type = "number",
            }
        end
}
