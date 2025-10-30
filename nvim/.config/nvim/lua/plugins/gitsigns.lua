-- lua/user/plugins/gitsigns.lua

return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "" },
        change       = { text = "" },
        delete       = { text = "" },
        topdelete    = { text = "‾" },
        changedelete = { text = "" },
      },

      -- This enables the inline blame information
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000, -- Delay before showing blame info
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    })
  end,
}

