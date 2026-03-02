return {
  'zbirenbaum/copilot.lua',
  -- dependencies = {
  --   "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  -- }
  cmd = 'Copilot',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('copilot').setup {
      -- suggestion = {
      --   auto_trigger = true,
      -- },
    }
  end,
}
