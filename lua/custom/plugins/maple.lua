-- maple.nvim is a notes plugin for neovim which allows you to have global, and project based notes directly in nvim

return {
  'forest-nvim/maple.nvim',
  config = function()
    require('maple').setup {
      -- Your configuration options here
    }
  end,
}
