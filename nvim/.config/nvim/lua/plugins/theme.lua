-- lua/user/plugins/theme.lua

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      integrations = {
        -- enable integrations with other plugins
        cmp = true,
        gitsigns = true,
        telescope = true,
        lualine = true,
      },
    })
    -- setup must be called before loading the colorscheme
    vim.cmd.colorscheme("catppuccin")
  end,
}

