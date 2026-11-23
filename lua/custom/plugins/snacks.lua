vim.pack.add {
  {
    src = "https://github.com/folke/snacks.nvim",
    priority = 1000
  },
}

require("snacks").setup {
  image = {
    resolve = function(path, src)
      local api = require "obsidian.api"
      if api.path_is_note(path) then
        return api.resolve_attachment_path(src)
      end
    end,
  },
}
