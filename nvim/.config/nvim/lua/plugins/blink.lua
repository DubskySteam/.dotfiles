return {
    "saghen/blink.cmp",
    version = "v1.2.0",
    event = "InsertEnter",
    dependencies = {{"rafamadriz/friendly-snippets"}},
    opts = {
        keymap = {
            ["<CR>"] = {"accept", "fallback"}
        },
        completion = {
            documentation = {
                treesitter_highlighting = true
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = true
                }
            }
        },
        signature = {
            enabled = true
        },
        sources = {
            default = {"lsp", "path", "snippets", "buffer"},
            providers = {}
        }
    },
    opts_extend = {"sources.default"}
}
