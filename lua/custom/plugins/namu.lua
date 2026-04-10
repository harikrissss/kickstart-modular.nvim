return {
  'bassamsdata/namu.nvim',
  config = function()
    require('namu').setup {
      -- Enable the modules you want
      namu_symbols = {
        enable = true,
        options = {}, -- here you can configure namu
      },
      -- Optional: Enable other modules if needed
      ui_select = { enable = false }, -- vim.ui.select() wrapper
    }
    -- === Suggested Keymaps: ===
    vim.keymap.set('n', '<leader>ls', ':Namu symbols<cr>', {
      desc = 'Jump to (L)SP (s)ymbol',
      silent = true,
    })
    vim.keymap.set('n', '<leader>lw', ':Namu workspace<cr>', {
      desc = '(L)SP Symbols - (W)orkspace',
      silent = true,
    })
  end,
}
