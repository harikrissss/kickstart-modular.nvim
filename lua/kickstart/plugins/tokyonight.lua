return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        style = 'night', -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
        light_style = 'day', -- The theme is used when the background is set to light
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = 'dark', -- style for sidebars, see below
          floats = 'dark', -- style for floating windows
        },
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        dim_inactive = true, -- dims inactive windows
        lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

        --- You can override specific color groups to use other groups or a hex color
        --- function will be called with a ColorScheme table
        ---@param colors ColorScheme
        on_colors = function(colors)
          colors.border_highlight = colors.blue

          -- brighten up the git colors, used for gitsigns (column and lualine)
          colors.git.add = colors.teal
          colors.git.change = colors.blue
          colors.git.delete = colors.red1

          if vim.o.background == 'dark' then
            -- Brighten changes within a line
            colors.diff.text = '#204b23'
            -- Make changed lines more green instead of blue
            colors.diff.add = '#182f23'
            -- Make deletes more saturated
            colors.diff.delete = '#4d1919'

            -- If night style, make bg_dark very slightly less dark
            colors.bg_dark = '#171821'
            colors.bg_statusline = colors.bg_dark
          end

          -- colors.orange = '#d77f4a' --#f4975f '#ff9e64' #ff966c #d77f4a
        end,

        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with a Highlights and ColorScheme table
        ---@param highlights tokyonight.Highlights
        ---@param colors ColorScheme
        on_highlights = function(highlights, colors)
          -- slightly brighter visual selection
          highlights.Visual.bg = '#2d3f6f'
          -- Keep visual for popup/picker highlights
          highlights.PmenuSel = { bg = highlights.Visual.bg }
          highlights.TelescopeSelection = { bg = highlights.Visual.bg }
          highlights.SnacksPickerCursorLine = { bg = highlights.Visual.bg }
          highlights.SnacksPickerListCursorLine = highlights.SnacksPickerCursorLine
          highlights.SnacksPickerPreviewCursorLine = highlights.SnacksPickerCursorLine

          if vim.o.background == 'dark' then
            -- Use bg.dark from storm (not night) for the cursor line background to make it more subtle
            highlights.CursorLine = { bg = '#1f2335' }

            -- Visual selection should match visual mode color, but more saturated
            highlights.Visual = { bg = '#2d213d' }

            -- Make TS context dimmer and color line numbers
            highlights.TreesitterContext = { bg = '#272d45' }
            highlights.TreesitterContextLineNumber = { fg = colors.fg_gutter, bg = '#272d45' }

            -- Make the colors in the Lualine x section dimmer
            local lualine = require 'lualine.themes.tokyonight-night'
            lualine.normal.x = { fg = highlights.Comment.fg, bg = colors.bg_statusline }

            -- modes: I want a more muted green for the insert line
            -- #1a2326 slightly less green
            -- #1f2a2e a little brighter
            -- #1d272a one notch less bright
            highlights.ModesInsertCursorLine = { bg = '#1f2a2e' }

            -- Don't want teal in neogit diff add
            -- highlights.NeogitDiffAddHighlight = { fg = '#abd282', bg = highlights.DiffAdd.bg }

            -- More subtle snacks indent colors
            highlights.SnacksIndent = { fg = '#1f202e' }
            highlights.SnacksIndentScope = highlights.LineNr
          -- highlights.SnacksIndentScope = { fg = c.bg_highlight }
          else
            -- Visual selection should match visual mode
            highlights.Visual = { bg = '#d6cae1' }

            -- Make TS context color line numbers
            highlights.TreesitterContextLineNumber = { fg = '#939aba', bg = '#b3b8d1' }

            -- Diff colors
            -- Brighten changes within a line
            highlights.DiffText = { bg = '#a3dca9' }
            -- Make changed lines more green instead of blue
            highlights.DiffAdd = { bg = '#cce5cf' }

            -- clean up Neogit diff colors (when committing)
            -- highlights.NeogitDiffAddHighlight = { fg = '#4d6534', bg = highlights.DiffAdd.bg }

            -- Make yaml properties and strings more distinct
            highlights['@property.yaml'] = { fg = '#006a83' }

            -- Make flash label legible in light mode
            if highlights.FlashLabel then
              highlights.FlashLabel.fg = colors.bg
            end
          end

          -- telescope
          highlights.TelescopeMatching = { fg = highlights.IncSearch.bg }

          -- cmp
          -- highlights.CmpItemAbbrMatchFuzzy = { fg = highlights.IncSearch.bg }
          -- highlights.CmpItemAbbrMatch = { fg = highlights.IncSearch.bg }
          -- Darken cmp menu (src for the completion)
          -- highlights.CmpItemMenu = highlights.CmpGhostText

          -- Blink
          highlights.Pmenu.bg = colors.bg
          highlights.PmenuMatch.bg = colors.bg
          highlights.BlinkCmpLabelMatch = { fg = highlights.IncSearch.bg }
          highlights.BlinkCmpSource = { fg = colors.terminal_black }

          -- FzfLua
          -- highlights.FzfLuaDirPart = highlights.NonText
          -- highlights.FzfLuaPathLineNr = { fg = colors.fg_dark }
          -- highlights.FzfLuaFzfCursorLine = highlights.NonText
          -- highlights.FzfLuaFzfMatch = { fg = highlights.IncSearch.bg }
          -- highlights.FzfLuaBufNr = { fg = colors.fg }

          -- Snacks
          highlights.SnacksPickerBufNr = highlights.NonText
          highlights.SnacksPickerMatch = { fg = highlights.IncSearch.bg }

          -- clean up Neogit diff colors (when committing)
          -- highlights.NeogitDiffContextHighlight = { bg = highlights.Normal.bg }
          -- highlights.NeogitDiffContext = { bg = highlights.Normal.bg }

          -- clean up gitsigns inline diff colors
          highlights.GitSignsChangeInLine = { fg = colors.git.change, reverse = true }
          highlights.GitSignsAddInLine = { fg = colors.git.add, reverse = true }
          highlights.GitSignsDeleteInLine = { fg = colors.git.delete, reverse = true }

          -- Make folds less prominent (especially important for DiffView)
          highlights.Folded = { fg = colors.blue0, italic = true }

          -- Make diff* transparent for DiffView file panel
          highlights.diffAdded = { fg = colors.git.add }
          highlights.diffRemoved = { fg = colors.git.delete }
          highlights.diffChanged = { fg = colors.git.change }

          -- Make lsp cursor word highlights dimmer
          highlights.LspReferenceWrite = { bg = colors.bg_highlight }
          highlights.LspReferenceText = { bg = colors.bg_highlight }
          highlights.LspReferenceRead = { bg = colors.bg_highlight }

          highlights.TelescopePromptTitle = {
            fg = colors.fg,
          }
          highlights.TelescopePromptBorder = {
            fg = colors.blue1,
          }
          highlights.TelescopeResultsTitle = {
            fg = colors.purple,
          }
          highlights.TelescopePreviewTitle = {
            fg = colors.orange,
          }

          -- Highlight undo/redo in green
          highlights.HighlightUndo = { fg = colors.bg, bg = colors.green }

          -- highlights.Marks = highlights.DiagnosticInfo
          highlights.MarkSignHL = highlights.DiagnosticInfo

          -- Less bright trailing space indicator
          highlights.MiniTrailspace = { fg = colors.red }

          -- Make win separator more prominent
          highlights.WinSeparator = { fg = colors.terminal_black }
        end,

        cache = true, -- When set to true, the theme will be cached for better performance

        ---@type table<string, boolean|{enabled:boolean}>
        plugins = {
          -- enable all plugins when not using lazy.nvim
          -- set to false to manually enable/disable plugins
          all = package.loaded.lazy == nil,
          -- uses your plugin manager to automatically enable needed plugins
          -- currently only lazy.nvim is supported
          auto = true,
          -- add any plugins here that you want to enable
          -- for all possible plugins, see:
          --   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
          -- telescope = true,
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
}
-- vim: ts=8 sts=2 sw=2 noet
