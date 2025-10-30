-- lua/user/plugins/telescope.lua

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6", -- choose a specific version for stability
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
      },
    })

    -- Add keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Search for files in project" })
    keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search for a string in project" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Search through open buffers" })
    keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help tags" })
  end,
}

