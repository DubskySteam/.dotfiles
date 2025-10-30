return {
  "dubskysteam/discord-send.nvim", 
  config = function()
    require("discord-send").setup({
      webhooks = {
        { name = "DubskysArchive", url = "https://discord.com/api/webhooks/1431042657999781999/HzCzpVUqqSnFWXb-bUBERppP_7UsHoh8N80j2iIdgQyMMNu4YKkW_vC9tx8n32LEixPS" },
        { name = "Moderator Chat", url = "https://discord.com/api/webhooks/1431055189066121336/s8wyrJoYxU_LoZZnq51s6EfAMpeioqYlhLiZiwxTaxZ8PwzEcqMKf-KGOnSiXZJeGmqE" },
      },
    })
  end,
  -- Add a keymap for convenience while testing
  keys = {
    { "<leader>ds", "<cmd>DiscordSend<CR>", desc = "Discord Send" },
    { "<leader>ds", "<cmd>DiscordSend<CR>", mode = "v", desc = "Discord Send (Visual)" },
  },
}
