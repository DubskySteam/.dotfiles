-- lua/user/plugins/lsp.lua

return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Useful status updates for LSP
    { "j-hui/fidget.nvim", opts = {} },

    -- Autocompletion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Setup nvim-cmp.
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })

    -- Keymaps for LSP
    local on_attach = function(_, bufnr)
      local keymap = vim.keymap
      local opts = { buffer = bufnr, silent = true }
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      keymap.set("n", "K", vim.lsp.buf.hover, opts)
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      keymap.set("n", "gr", vim.lsp.buf.references, opts)
    end

    -- Setup language servers.
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls" },
      handlers = {
        function(server_name) -- default handler
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end,
      },
    })
  end,
}

