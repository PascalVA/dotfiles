-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "// %s"
  end,
  pattern = { "hjson" },
})

-- reload colorscheme based on gsettings when SIGUSR1 is received
vim.api.nvim_create_autocmd("Signal", {
  callback = function()
    local f = io.popen("gsettings get org.gnome.desktop.interface color-scheme")
    local colorscheme = f:read()
    require("onedark").setup({ style = (colorscheme == "'prefer-light'") and "light" or "dark" })
    require("onedark").load()
  end,
})
