return {
    'vyfor/cord.nvim',
    build = ':Cord update',
    config = function()
        require('cord').setup {
            idle = {
                enabled = false,
            }
        }
    end
}
