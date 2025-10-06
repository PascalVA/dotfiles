vim.opt.background = "dark"
return {
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "cool",
    },
    config = function(_, opts)
      local onedark = require("onedark")
      onedark.setup(opts)
      onedark.load()
    end,
  },
}
