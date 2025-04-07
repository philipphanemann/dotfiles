return {
  {
    "catppuccin/nvim",
    enabled = false,
    name = "catppuccin",
    opts = {
      flavour = "macchiato",
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" }, -- moon, stomr, night, day
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin",
      colorscheme = "tokyonight",
    },
  },
  {
    "loganswartz/sunburn.nvim",
    dependencies = { "loganswartz/polychrome.nvim" },
    -- you could do this, or use the standard vimscript `colorscheme sunburn`
    config = function()
      vim.cmd.colorscheme("sunburn")
    end,
  },
}
