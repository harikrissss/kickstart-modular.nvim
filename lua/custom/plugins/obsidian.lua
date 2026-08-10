vim.pack.add {
  {
    src = "https://github.com/obsidian-nvim/obsidian.nvim",
    version = vim.version.range "*", -- use latest release, remove to use latest commit
  },
}

require("obsidian").setup {
  legacy_commands = false, -- this will be removed in 4.0.0
  workspaces = {
    {
      name = "work",
      path = '/Users/hari-24312/Documents/obsidian-vault',
    },
  },

  notes_subdir = "src/notes",
  new_notes_location = "notes_subdir",

  note_id_func = function(title)
    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
    -- In this case a note with the title 'My new note' will be given an ID that looks
    -- like 'my_new_note', and therefore the file name 'my_new_note.md'
    local suffix = ""
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9_-]", ""):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return suffix
  end,

  templates = {
    folder = "src/templates",
    date_format = "YYYY-MM-DD",
    time_format = "HH:mm",
    substitutions = {
      date = function(_, suffix)
        local format = suffix or Obsidian.opts.templates.date_format
        return require("obsidian.util").format_date(os.time(), format)
      end,
      time = function(_, suffix)
        local format = suffix or Obsidian.opts.templates.time_format
        return require("obsidian.util").format_date(os.time(), format)
      end,
      title = function(ctx)
        return ctx.partial_note and ctx.partial_note:display_name()
      end,
      id = function(ctx)
        return ctx.partial_note and ctx.partial_note.id
      end,
      path = function(ctx)
        return ctx.partial_note and tostring(ctx.partial_note.path)
      end,
    },
  },

  picker = {
    name = "telescope.nvim",
  },

  daily_notes = {
    enabled = true,
    folder = "src/notes/daily-notes",
  },

  attachments = {
    folder = 'src/assets/imgs',
  },
}
