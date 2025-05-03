-- A Neovim plugin that colorizes multiple search terms with multiple distinct colors for better visual tracking.

return {
  'hamidi-dev/kaleidosearch.nvim',
  dependencies = {
    'tpope/vim-repeat', -- optional for dot-repeatability
    'stevearc/dressing.nvim', -- optional for nice input
  },

  config = function()
    require('kaleidosearch').setup {
      highlight_group_prefix = 'WordColor_', -- Prefix for highlight groups
      case_sensitive = false, -- Case sensitivity for matching
      keymaps = {
        enabled = true, -- Set to false to disable default keymaps
        open = '<leader>cs', -- Open input prompt for search
        clear = '<leader>cc', -- Clear highlights
        add_new_word = '<leader>cn', -- Add a new word to existing highlights
        add_cursor_word = '<leader>ca', -- Add word under cursor to highlights
        opts = {
          noremap = true,
          silent = true,
        },
      },
    }
  end,
}
