-- A snazzy bufferline for Neovim

return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      mode = 'tabs',
      always_show_bufferline = true,
      separator_style = 'slope',
      offsets = {
        {
          filetype = 'neo-tree',
          separator = true,
        },
      },
    },
  },
}
