-- Minimal Eye-candy keys screencaster for Neovim 200 ~ LOC

return {
  'nvzone/showkeys',
  cmd = 'ShowkeysToggle',
  opts = {
    winhl = 'FloatBorder:Comment,Normal:Normal',
    timeout = 3,
    maxkeys = 5,
    show_count = false,
    excluded_modes = {}, -- example: {"i"}

    -- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
    position = 'bottom-right',

    keyformat = {
      ['<BS>'] = '󰁮 ',
      ['<CR>'] = '󰘌',
      ['<Space>'] = '󱁐',
      ['<Up>'] = '󰁝',
      ['<Down>'] = '󰁅',
      ['<Left>'] = '󰁍',
      ['<Right>'] = '󰁔',
      ['<PageUp>'] = 'Page 󰁝',
      ['<PageDown>'] = 'Page 󰁅',
      ['<M>'] = 'Alt',
      ['<C>'] = 'Ctrl',
    },
  },
}
