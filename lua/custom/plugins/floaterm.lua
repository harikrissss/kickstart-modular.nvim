-- Beautiful floating terminal manager for Neovim

return {
  'nvzone/floaterm',
  dependencies = 'nvzone/volt',
  opts = {
    border = false,
    size = { h = 60, w = 70 },

    -- to use, make this func(buf)
    mappings = {
      sidebar = function(buf)
        vim.keymap.set('n', '<C-h>', require('floaterm.api').switch_wins, { buffer = buf })
      end,
      term = nil,
    },

    -- Default sets of terminals you'd like to open
    terminals = {
      { name = 'Terminal' },
      -- cmd can be function too
      { name = 'Neofetch', cmd = 'neofetch' },
      -- More terminals
    },
  },
  cmd = 'FloatermToggle',
}
