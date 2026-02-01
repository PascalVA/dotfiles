return {
  "yetone/avante.nvim",
  build = "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = "openai",
    providers = {
      openai = {
        endpoint = "https://openrouter.ai/api/v1",
        -- model = "claude-sonnet-4-20250514",
        model = "anthropic/claude-sonnet-4.5",
        timeout = 60000, -- Increased timeout for complex requests
        api_key_name = "OPENROUTER_API_KEY",
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192,
        },
      },
    },
    -- Input configuration moved to correct location
    input = {
      provider = "snacks",
      provider_opts = {
        -- Additional snacks.input options
        title = "Avante Input",
        icon = " ",
      },
    },
    windows = {
      input = {
        height = 20,
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- Additional recommended dependencies
    "stevearc/dressing.nvim", -- Enhanced UI components
    "nvim-tree/nvim-web-devicons", -- Icons support
  },
}
