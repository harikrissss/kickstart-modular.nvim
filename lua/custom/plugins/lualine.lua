-- A blazing fast and easy to configure neovim statusline plugin written in pure lua.

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  --[[ opts = {
    sections = {
      lualine_x = {
        function()
          local ok, pomo = pcall(require, 'pomo')
          if not ok then
            return ''
          end

          local timer = pomo.get_first_to_finish()
          if timer == nil then
            return ''
          end

          return '󰄉 ' .. tostring(timer)
        end,
        'encoding',
        'fileformat',
        'filetype',
      },
    },
  }, ]]
}

--[[ opts = {
    component_separators = { left = ' ', right = ' ' },
    section_separators = { left = ' ', right = ' ' },
    theme = theme,
    globalstatus = true,
    disabled_filetypes = { statusline = { 'dashboard' } },
    sections = {
      lualine_a = {
        { 'mode', icon = { '' } },
        { 'branch', icon = { '' }, padding = { right = 2, left = 2 } },
        { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
        { 'filename', path = 0, symbols = { modified = '', readonly = '' }, padding = { left = 0 } },
      },
      lualine_b = {},
      lualine_c = {
        {
          function()
            return require('tmux-status').tmux_windows()
          end,
          cond = function()
            return require('tmux-status').show()
          end,
          padding = { left = 3 },
        },
      },
      lualine_x = {
        -- {
        --   ---@diagnostic disable-next-line: undefined-field
        --   require("noice").api.status.command.get,
        --   ---@diagnostic disable-next-line: undefined-field
        --   cond = require("noice").api.status.command.has,
        --   color = { fg = "#ff9e64" },
        -- },
        {
          function()
            return '󱑍 ' .. os.date '%X'
          end,
          cond = function()
            return os.getenv 'TMUX' == nil
          end,
        },
      },
      lualine_y = {
        { 'selectioncount' },
        { 'diagnostics' },
        { 'progress', padding = { left = 2, right = 1 } },
        -- TODO: do not show when no tmux
        { 'location', padding = { right = 1 } },
      },
      lualine_z = {
        -- TODO: show when no tmux available
        -- { "location" },
        {
          function()
            return require('tmux-status').tmux_battery()
          end,
          cond = function()
            return require('tmux-status').show()
          end,
          padding = { left = 1, right = 1 },
        },
        {
          function()
            return require('tmux-status').tmux_datetime()
          end,
          cond = function()
            return require('tmux-status').show()
          end,
          padding = { left = 1, right = 1 },
        },
        {
          function()
            return require('tmux-status').tmux_session()
          end,
          cond = function()
            return require('tmux-status').show()
          end,
          padding = { left = 1, right = 1 },
        },
      },
    },
    tabline = {
      lualine_a = {
        {
          'tabs',
          mode = 1,
          path = 0,
          show_modified_status = true,
          max_length = vim.o.columns,
          symbols = {
            modified = '',
          },
          tabs_color = {
            active = 'custom_tab_active',
          },
        },
      },
    },
    extensions = {
      'quickfix',
      'neo-tree',
      'lazy',
      'oil',
      'trouble',
    },
  }, ]]

-- vim: ts=8 sts=2 sw=2 noet
