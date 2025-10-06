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
        endpoint = "cmd:echo $ANTHROPIC_BASE_URL",
        -- model = "claude-sonnet-4-20250514",
        model = "claude-3-5-haiku-latest",
        timeout = 60000, -- Increased timeout for complex requests
        api_key_name = "cmd:echo $ANTHROPIC_AUTH_TOKEN",
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
