return {
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
        terminal_colors = true,
        devicons = true,
        filter = "classic",
          background_clear = {
            "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
            "float_win",
            "toggleterm",
            "telescope",
            "which-key",
            "renamer",
            "notify",
            "nvim-tree",
            "neo-tree",
          },
      })
      vim.cmd("colorscheme monokai-pro")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai-pro",
    },
  },
}

