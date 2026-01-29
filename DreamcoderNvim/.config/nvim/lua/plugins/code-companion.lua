return {
  "olimorris/codecompanion.nvim",
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
    -- Requires the notifier file we just created
    require("plugins.codecompanion.codecompanion-notifier"):init()

    local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionInlineFinished",
      group = group,
      callback = function(request)
        vim.lsp.buf.format({ bufnr = request.buf })
      end,
    })
  end,
  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionCmd",
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Toggle [C]hat" },
    { "<leader>an", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "AI [N]ew Chat" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI [A]ction" },
    { "ga", "<cmd>CodeCompanionChat Add<CR>", mode = { "v" }, desc = "AI [A]dd to Chat" },
    { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = { "v" }, desc = "AI [E]xplain" },
  },
  config = true,
  opts = {
    adapters = {
      copilot_4o = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = { model = { default = "gpt-4o" } },
        })
      end,
      copilot_gemini = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = { model = { default = "gemini-2.0-pro" } },
        })
      end,
    },
    display = {
      diff = {
        enabled = true,
        close_chat_at = 240,
        layout = "vertical",
        provider = "default",
      },
      chat = {
        window = { position = "left" },
      },
    },
    strategies = {
      inline = {
        keymaps = {
          accept_change = { modes = { n = "ga" }, description = "Accept change" },
          reject_change = { modes = { n = "gr" }, description = "Reject change" },
        },
      },
      chat = {
        adapter = "copilot",
        roles = {
          llm = function(adapter) return "🤖 " .. adapter.formatted_name end,
          user = "Dreamcoder",
        },
      },
    },
  },
}
