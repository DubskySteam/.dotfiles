-- lua/user/plugins/telescope.lua

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6", -- choose a specific version for stability
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Search for files in project" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Search for a string in project" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Search through open buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Search help tags" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        path_display = { "truncate" },
      },
    })
  end,
}

