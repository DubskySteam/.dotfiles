return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function get_lsp_servers()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if #clients == 0 then
        return "No LSP"
      end
      local client_names = {}
      for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
      end
      return "LSP: " .. table.concat(client_names, ", ")
    end

    -- Example for showing language version (add more as needed)
    local function get_language_version()
        -- Example for Lua
        if vim.bo.filetype == 'lua' then
            return _VERSION -- Returns 'Lua 5.1' for example
        end
        -- Add other languages here, e.g., for node:
        -- if vim.bo.filetype == 'javascript' or vim.bo.filetype == 'typescript' then
        --   return "Node: " .. vim.fn.system("node -v"):gsub("\n", "")
        -- end
        return ""
    end

    require("lualine").setup({
      options = {
        theme = "catppuccin",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", { "diff",
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed
              }
            end
          end
        }},
        lualine_c = {},
        lualine_x = { get_lsp_servers, "filetype", get_language_version },
        lualine_y = {},
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = { "location" },
      },
    })
  end,
}

