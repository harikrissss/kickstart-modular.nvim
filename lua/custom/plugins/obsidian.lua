-- Obsidian 🤝 Neovim

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

    -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
    -- levels defined by "vim.log.levels.\*".
    log_level = vim.log.levels.INFO,

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = 'src/notes/dailies',
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = '%Y-%m-%d',
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = '%B %-d, %Y',
      -- Optional, default tags to add to each new daily note created.
      default_tags = { 'daily-notes' },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
      -- Optional, if you want `Obsidian yesterday` to return the last work day or `Obsidian tomorrow` to return the next work day.
      workdays_only = true,
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Enables completion using nvim_cmp
      nvim_cmp = false,
      -- Enables completion using blink.cmp
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
      -- Set to false to disable new note creation in the picker
      create_new = true,
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
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix '.md'
    end,

    -- Optional, customize how wiki links are formatted. You can set this to one of:
    -- _ "use_alias_only", e.g. '[[Foo Bar]]'
    -- _ "prepend*note_id", e.g. '[[foo-bar|Foo Bar]]'
    -- * "prepend*note_path", e.g. '[[foo-bar.md|Foo Bar]]'
    -- * "use_path_only", e.g. '[[foo-bar.md]]'
    -- Or you can set it to a function that takes a table of options and returns a string, like this:
    wiki_link_func = function(opts)
      return require('obsidian.util').wiki_link_id_prefix(opts)
    end,

    -- Optional, customize how markdown links are formatted.
    markdown_link_func = function(opts)
      return require('obsidian.util').markdown_link(opts)
    end,

    -- Either 'wiki' or 'markdown'.
    preferred_link_style = 'wiki',

    ---@class obsidian.config.FrontmatterOpts
    ---
    --- Whether to enable frontmatter, boolean for global on/off, or a function that takes filename and returns boolean.
    ---@field enabled? (fun(fname: string?): boolean)|boolean
    ---
    --- Function to turn Note attributes into frontmatter.
    ---@field func? fun(note: obsidian.Note): table<string, any>
    --- Function that is passed to table.sort to sort the properties, or a fixed order of properties.
    ---
    --- List of string that sorts frontmatter properties, or a function that compares two values, set to vim.NIL/false to do no sorting
    ---@field sort? string[] | (fun(a: any, b: any): boolean) | vim.NIL | boolean
    frontmatter = {
      -- `true` indicates that you want obsidian.nvim to manage frontmatter.
      enabled = true,
      -- Optional, alternatively you can customize the frontmatter data.
      func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
      sort = { 'id', 'aliases', 'tags' },
    },

    -- Optional, for templates (see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Using-templates)
    templates = {
      folder = 'src/templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      -- A map for custom variables, the key should be the variable and the value a function.
      -- Functions are called with obsidian.TemplateContext objects as their sole parameter.
      -- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions
      substitutions = {},

      -- A map for configuring unique directories and paths for specific templates
      --- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#customizations
      customizations = {},
    },

    -- Sets how you follow URLs
    ---@param url string
    follow_url_func = function(url)
      vim.ui.open(url)
      -- vim.ui.open(url, { cmd = { "firefox" } })
    end,

    -- Sets how you follow images
    ---@param img string
    follow_img_func = function(img)
      vim.ui.open(img)
      -- vim.ui.open(img, { cmd = { "loupe" } })
    end,

    ---@class obsidian.config.OpenOpts
    ---
    ---Opens the file with current line number
    ---@field use_advanced_uri? boolean
    ---
    ---Function to do the opening, default to vim.ui.open
    ---@field func? fun(uri: string)
    open = {
      use_advanced_uri = false,
      func = vim.ui.open,
    },

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      name = 'snacks.pick',
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = '<C-x>',
        -- Insert a link to the selected note.
        insert_link = '<C-l>',
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = '<C-x>',
        -- Insert a tag at the current location.
        insert_tag = '<C-l>',
      },
    },

    -- Optional, by default, `:ObsidianBacklinks` parses the header under
    -- the cursor. Setting to `false` will get the backlinks for the current
    -- note instead. Doesn't affect other link behaviour.
    backlinks = {
      parse_headers = true,
    },

    ---@class obsidian.config.SearchOpts
    ---
    ---@field sort_by string
    ---@field sort_reversed boolean
    ---@field max_lines integer
    search = {
      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:Obsidian quick_switch` will show the notes sorted by latest modified time
      sort_by = 'modified',
      sort_reversed = true,
      -- Set the maximum number of lines to read from notes on disk when performing certain searches.
      max_lines = 1000,
    },

    -- Optional, determines how certain commands open notes. The valid options are:
    -- 1. "current" (the default) - to always open in the current window
    -- 2. "vsplit" - only open in a vertical split if a vsplit does not exist.
    -- 3. "hsplit" - only open in a horizontal split if a hsplit does not exist.
    -- 4. "vsplit_force" - always open a new vertical split if the file is not in the adjacent vsplit.
    -- 5. "hsplit_force" - always open a new horizontal split if the file is not in the adjacent hsplit.
    open_notes_in = 'current',

    -- Optional, define your own callbacks to further customize behavior.
    callbacks = {
      -- Runs at the end of `require("obsidian").setup()`.
      ---@param client obsidian.Client
      post_setup = function(client) end,

      -- Runs anytime you enter the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      enter_note = function(client, note) end,

      -- Runs anytime you leave the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      leave_note = function(client, note) end,

      -- Runs right before writing the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      pre_write_note = function(client, note) end,

      -- Runs anytime the workspace is set/changed.
      ---@param workspace obsidian.Workspace
      post_set_workspace = function(workspace) end,
    },

    ---@class obsidian.config.AttachmentsOpts
    ---
    ---Default folder to save images to, relative to the vault root.
    ---@field img_folder? string
    ---
    ---Default name for pasted images
    ---@field img_name_func? fun(): string
    ---
    ---Default text to insert for pasted images, for customizing, see: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Images
    ---@field img_text_func? fun(path: obsidian.Path): string
    ---
    ---Whether to confirm the paste or not. Defaults to true.
    ---@field confirm_img_paste? boolean
    attachments = {
      img_folder = 'src/assets/imgs',
      img_name_func = function()
        return string.format('Pasted image %s', os.date '%Y%m%d%H%M%S')
      end,
      confirm_img_paste = true,
    },

    ---@deprecated in favor of the footer option below
    -- statusline = {
    --   enabled = true,
    --   format = '{{properties}} properties {{backlinks}} backlinks {{words}} words {{chars}} chars',
    -- },

    ---@class obsidian.config.FooterOpts
    ---
    ---@field enabled? boolean
    ---@field format? string
    ---@field hl_group? string
    ---@field separator? string|false Set false to disable separator; set an empty string to insert a blank line separator.
    footer = {
      enabled = true,
      format = '{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars',
      hl_group = 'Comment',
      separator = string.rep('-', 80),
    },
    ---@class obsidian.config.CheckboxOpts
    ---
    ---Order of checkbox state chars, e.g. { " ", "x" }
    ---@field order? string[]
    checkbox = {
      order = { ' ', '~', '!', '>', 'x' },
    },

    legacy_commands = false,
  },
}
