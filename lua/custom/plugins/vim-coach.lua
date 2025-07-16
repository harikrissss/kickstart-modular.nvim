-- Your Personal Coach

return {
  'shahshlok/vim-coach.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('vim-coach').setup {
      -- Disable default keymaps
      -- Set vim.g.vim_coach_no_default_keymaps = 1 before setup

      window = {
        border = 'rounded',
        title_pos = 'center',
      },
      keymaps = {
        copy_keymap = '<C-y>',
        close = '<Esc>',
      },
    }
  end,
  keys = {
    { '<leader>?', '<cmd>VimCoach<cr>', desc = 'Vim Coach' },
  },
}
