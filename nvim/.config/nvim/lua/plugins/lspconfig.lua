return {
    "mason-org/mason-lspconfig.nvim",
    event = "BufReadPost",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "clangd",
      },
      automatic_installation = true,
    },
  }