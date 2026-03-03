return {
  {
    "navarasu/onedark.nvim",
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local f = io.popen("gsettings get org.gnome.desktop.interface color-scheme")
        local colorscheme = f:read()
        require("onedark").setup({
          style = (colorscheme == "'prefer-light'") and "light" or "dark",
        })
        require("onedark").load()
      end,
    },
  },
}
