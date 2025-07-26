-- Not a plugin manager, but plugin magazine 💅

return {
  'alex-popov-tech/store.nvim',
  dependencies = {
    'OXY2DEV/markview.nvim', -- optional, for pretty readme preview / help window
  },
  cmd = 'Store',
  keys = {
    { '<leader>S', '<cmd>Store<cr>', desc = 'Open Plugin Store' },
  },
  opts = {
    -- optional configuration here
    -- Window dimensions (percentages or absolute)
    width = 0.8,
    height = 0.8,

    -- Layout proportions (must sum to 1.0)
    proportions = {
      list = 0.3, -- 30% for repository list
      preview = 0.7, -- 70% for preview pane
    },

    -- Modal appearance
    modal = {
      border = 'rounded', -- Border style
      zindex = 50, -- Z-index for modal windows
    },

    -- Keybindings
    keybindings = {
      help = '?', -- Show help
      close = 'q', -- Close modal
      filter = 'f', -- Open filter input
      refresh = 'r', -- Refresh data
      open = '<cr>', -- Open selected repository
      switch_focus = '<tab>', -- Switch focus between panes
    },

    -- Behavior
    preview_debounce = 150, -- ms delay for preview updates
    cache_duration = 24 * 60 * 60, -- 24 hours in seconds
    logging = 'off', -- Levels: off, error, warn, log, debug
  },
}
