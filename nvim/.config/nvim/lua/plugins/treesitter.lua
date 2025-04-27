return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = { "lua", "vim", "markdown", "c", "cpp", "zig", "java", "kotlin", "json" },
            sync_install = false,
            auto_install = false,
            ignore_install = { "javascript", "typescript" },
            highlight = {
                enable = true,
                disable = { "" },
                additional_vim_regex_highlighting = false,
            },
        }
    end
}
