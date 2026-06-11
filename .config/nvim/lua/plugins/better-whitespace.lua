-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  "ntpeters/vim-better-whitespace",
  event = "VeryLazy",
  config = function()
    vim.g.better_whitespace_filetypes_blacklist = {
      "diff",
      "git",
      "gitcommit",
      "unite",
      "qf",
      "help",
      "markdown",
      "fugitive", -- default
      "alpha",
      "dashboard",
      "snacks_dashboard",
    }
  end,
}
