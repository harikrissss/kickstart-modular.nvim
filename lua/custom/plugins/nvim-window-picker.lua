-- This plugins prompts the user to pick a window and returns the window id of the picked window

return {
  's1n7ax/nvim-window-picker',
  name = 'window-picker',
  event = 'VeryLazy',
  version = '2.*',
  config = function()
    require('window-picker').setup()
  end,
}
