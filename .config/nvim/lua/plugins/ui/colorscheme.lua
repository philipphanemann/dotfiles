return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = { style = 'moon' }, -- moon, storm, night, day
    config = function()
      vim.cmd('colorscheme tokyonight')
    end,
  },
  {
    'loganswartz/sunburn.nvim',
    dependencies = { 'loganswartz/polychrome.nvim' },
    -- you could do this, or use the standard vimscript `colorscheme sunburn`
    config = function()
      vim.cmd.colorscheme 'sunburn'
    end,
  },
}
