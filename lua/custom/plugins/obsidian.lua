return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,

    -- A list of workspace names, paths, and configuration overrides.
    -- If you use the Obsidian app, the 'path' of a workspace should generally be
    -- your vault root (where the `.obsidian` folder is located).
    -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
    -- the workspace to the first workspace in the list whose `path` is a parent of the
    -- current markdown file being edited.
    workspaces = {
      {
        name = 'personal',
        path = '/home/hari-24312/Documents/obsidian-vault',
      },
    },

    -- Alternatively - and for backwards compatibility - you can set 'dir' to a single path instead of
    -- 'workspaces'. For example:
    -- dir = "~/vaults/work",

    -- Optional, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = 'src/notes',

    ---@class obsidian.config.DailyNotesOpts
    ---
    ---@field folder? string
    ---@field alias_format? string
    ---@field template? string
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = 'src/notes/dailies',
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = '%B %-d, %Y',
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = 'daily_template.md',
    },

    -- Where to put new notes. Valid options are
    -- _ "current_dir" - put new notes in same directory as the current buffer.
    -- _ "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = 'notes_subdir',

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'.
      -- You may have as many periods in the note ID as you'd like—the ".md" will be added automatically
      local suffix = ''
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(' ', '_'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return suffix
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix '.md'
    end,

    -- Optional, for templates (see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Using-templates)
    ---@class obsidian.config.TemplateOpts
    ---
    ---@field folder string|obsidian.Path|?
    ---@field date_format string|?
    ---@field time_format string|?
    templates = {
      folder = 'src/templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },

    ---@class obsidian.config.PickerOpts
    ---
    ---@field name obsidian.config.Picker|?
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      name = 'telescope.nvim',
    },

    ---@class obsidian.config.AttachmentsOpts
    ---
    ---Default folder to save images to, relative to the vault root (/) or current dir (.), see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Images#change-image-save-location
    ---@field folder? string
    attachments = {
      folder = 'src/assets/imgs',
    },
  },
}
