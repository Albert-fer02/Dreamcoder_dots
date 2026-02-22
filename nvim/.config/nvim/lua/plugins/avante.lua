return {
  {
    "yetone/avante.nvim",
    build = function()
      -- conditionally use the correct build system for the current OS
      if vim.fn.has("win32") == 1 then
        return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      else
        return "make"
      end
    end,
    event = "VeryLazy",
    version = false, 
    opts = function(_, opts)
      return {
        provider = "copilot",
        providers = {
          copilot = {
            model = "claude-sonnet-4",
          },
        },
        cursor_applying_provider = "copilot",
        auto_suggestions_provider = "copilot",
        behaviour = {
          enable_cursor_planning_mode = true,
        },
        file_selector = {
          provider = "snacks", 
          provider_opts = {},
        },
        windows = {
          position = "left", 
          width = 30, 
          sidebar_header = {
            enabled = true,
            align = "center",
            rounded = false,
          },
        },
        system_prompt = "You are Dreamcoder's AI Assistant. Act as a Senior Software Engineer specializing in Arch Linux, Rust, and React 19. Be concise, technical, and pragmatic.",
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
    },
  },
}
