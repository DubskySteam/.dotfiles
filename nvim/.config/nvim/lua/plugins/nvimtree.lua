-- lua/user/plugins/nvim-tree.lua

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- for file icons
  config = function()
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
      },
      -- Custom mappings for creating, deleting, and renaming files
      view = {
        width = 30,
        },
      -- Show git status icons
      renderer = {
        icons = {
          show = {
            git = true,
          },
        },
      },
    })
  end,
}

