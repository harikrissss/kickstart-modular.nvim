return {
  'nvzone/timerly',
  dependencies = {
    'nvzone/volt',
  },
  opts = {
    minutes = { 25, 5 },
    on_start = nil, -- func
    on_finish = function()
      vim.notify "Timerly: time's up!"
    end,
    mapping = nil, -- is func
    position = 'bottom-right', -- top-left, top-right, bottom-left, bottom-right
    -- or function(w, h) return row, col end , w - w of window, arg passed by plugin
  },
}
