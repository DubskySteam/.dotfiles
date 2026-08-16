return {
  "dubskysteam/discord-send.nvim",
  cmd = "DiscordSend",
  config = function()
    local webhooks = {}
    local function add(name, env)
      local url = vim.env[env]
      if url and url ~= "" then
        table.insert(webhooks, { name = name, url = url })
      end
    end
    add("DubskysArchive", "DISCORD_WEBHOOK_ARCHIVE")
    add("Moderator Chat", "DISCORD_WEBHOOK_MODERATOR")

    require("discord-send").setup({ webhooks = webhooks })
  end,
  keys = {
    { "<leader>ds", "<cmd>DiscordSend<CR>", desc = "Discord Send" },
    { "<leader>ds", "<cmd>DiscordSend<CR>", mode = "v", desc = "Discord Send (Visual)" },
  },
}
