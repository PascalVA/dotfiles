return {

  -- {
  --   "MarcoKorinth/onehalf.nvim",
  --   lazy = false,
  -- },
  -- {
  --   "navarasu/onedark.nvim",
  --   lazy = false,
  -- },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "cool",
      })
      -- Enable theme
      require("onedark").load()
    end,
  },
  -- {
  --   "EdenEast/nightfox.nvim",
  --   lazy = false,
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "onedark",
  --   },
  -- },
}
