-- lua/user/plugins/dashboard.lua

return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter", -- load on startup
  config = function()
    require("dashboard").setup({
      theme = "doom",
      config = {
        week_header = {
          enable = true,
        },
        center = {
          { action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
          { action = "e", desc = " New file", icon = " ", key = "n" },
          { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
          { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
        },
      },
    })
  end,
}

