---@module 'lazy'
---@type LazySpec
return {
  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      require('mini.comment').setup()

      require('mini.operators').setup()

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      local MiniFiles = require 'mini.files'
      MiniFiles.setup()

      vim.keymap.set('n', '-', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end, { desc = 'Open Mini Files' })

      -- https://github.com/nvim-mini/mini.nvim/discussions/2173
      -- Window width based on the offset from the center, i.e. center window
      -- is 60, then next over is 20, then the rest are 10.
      -- Can use more resolution if you want like { 60, 20, 20, 10, 5 }
      local widths = { 60, 20, 10 }

      local ensure_center_layout = function(ev)
        local state = MiniFiles.get_explorer_state()
        if state == nil then
          return
        end

        -- Compute "depth offset" - how many windows are between this and focused
        local path_this = vim.api.nvim_buf_get_name(ev.data.buf_id):match '^minifiles://%d+/(.*)$'
        local depth_this
        for i, path in ipairs(state.branch) do
          if path == path_this then
            depth_this = i
          end
        end
        if depth_this == nil then
          return
        end
        local depth_offset = depth_this - state.depth_focus

        -- Adjust config of this event's window
        local i = math.abs(depth_offset) + 1
        local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
        win_config.width = i <= #widths and widths[i] or widths[#widths]

        win_config.zindex = 99
        win_config.col = math.floor(0.5 * (vim.o.columns - widths[1]))
        local sign = depth_offset == 0 and 0 or (depth_offset > 0 and 1 or -1)
        for j = 1, math.abs(depth_offset) do
          -- widths[j+1] for the negative case because we don't want to add the center window's width
          local prev_win_width = (sign == -1 and widths[j + 1]) or widths[j] or widths[#widths]
          -- Add an extra +2 each step to account for the border width
          local new_col = win_config.col + sign * (prev_win_width + 2)
          if (new_col < 0) or (new_col + win_config.width > vim.o.columns) then
            win_config.zindex = win_config.zindex - 1
            break
          end
          win_config.col = new_col
        end

        win_config.height = depth_offset == 0 and 24 or 20
        win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
        win_config.border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
        win_config.footer = { { tostring(depth_offset), 'Normal' } }
        vim.api.nvim_win_set_config(ev.data.win_id, win_config)
      end

      vim.api.nvim_create_autocmd('User', { pattern = 'MiniFilesWindowUpdate', callback = ensure_center_layout })

      -- https://gist.github.com/bassamsdata/eec0a3065152226581f8d4244cce9051#file-notes-md
      local nsMiniFiles = vim.api.nvim_create_namespace 'mini_files_git'
      local autocmd = vim.api.nvim_create_autocmd
      local _, MiniFiles = pcall(require, 'mini.files')

      -- Cache for git status
      local gitStatusCache = {}
      local cacheTimeout = 2000 -- in milliseconds
      local uv = vim.uv or vim.loop

      local function isSymlink(path)
        local stat = uv.fs_lstat(path)
        return stat and stat.type == 'link'
      end

      ---@type table<string, {symbol: string, hlGroup: string}>
      ---@param status string
      ---@return string symbol, string hlGroup
      local function mapSymbols(status, is_symlink)
        local statusMap = {
	  -- stylua: ignore start 
	  [" M"] = { symbol = "•", hlGroup  = "MiniDiffSignChange"}, -- Modified in the working directory
	  ["M "] = { symbol = "✹", hlGroup  = "MiniDiffSignChange"}, -- modified in index
	  ["MM"] = { symbol = "≠", hlGroup  = "MiniDiffSignChange"}, -- modified in both working tree and index
	  ["A "] = { symbol = "+", hlGroup  = "MiniDiffSignAdd"   }, -- Added to the staging area, new file
	  ["AA"] = { symbol = "≈", hlGroup  = "MiniDiffSignAdd"   }, -- file is added in both working tree and index
	  ["D "] = { symbol = "-", hlGroup  = "MiniDiffSignDelete"}, -- Deleted from the staging area
	  ["AM"] = { symbol = "⊕", hlGroup  = "MiniDiffSignChange"}, -- added in working tree, modified in index
	  ["AD"] = { symbol = "-•", hlGroup = "MiniDiffSignChange"}, -- Added in the index and deleted in the working directory
	  ["R "] = { symbol = "→", hlGroup  = "MiniDiffSignChange"}, -- Renamed in the index
	  ["U "] = { symbol = "‖", hlGroup  = "MiniDiffSignChange"}, -- Unmerged path
	  ["UU"] = { symbol = "⇄", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged
	  ["UA"] = { symbol = "⊕", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged and added in working tree
	  ["??"] = { symbol = "?", hlGroup  = "MiniDiffSignDelete"}, -- Untracked files
	  ["!!"] = { symbol = "!", hlGroup  = "MiniDiffSignChange"}, -- Ignored files
          -- stylua: ignore end
        }

        local result = statusMap[status] or { symbol = '?', hlGroup = 'NonText' }
        local gitSymbol = result.symbol
        local gitHlGroup = result.hlGroup

        local symlinkSymbol = is_symlink and '↩' or ''

        -- Combine symlink symbol with Git status if both exist
        local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub('^%s+', ''):gsub('%s+$', '')
        -- Change the color of the symlink icon from "MiniDiffSignDelete" to something else
        local combinedHlGroup = is_symlink and 'MiniDiffSignDelete' or gitHlGroup

        return combinedSymbol, combinedHlGroup
      end

      ---@param cwd string
      ---@param callback function
      ---@return nil
      local function fetchGitStatus(cwd, callback)
        local clean_cwd = cwd:gsub('^minifiles://%d+/', '')
        ---@param content table
        local function on_exit(content)
          if content.code == 0 then
            callback(content.stdout)
            -- vim.g.content = content.stdout
          end
        end
        ---@see vim.system
        vim.system({ 'git', 'status', '--ignored', '--porcelain' }, { text = true, cwd = clean_cwd }, on_exit)
      end

      ---@param buf_id integer
      ---@param gitStatusMap table
      ---@return nil
      local function updateMiniWithGit(buf_id, gitStatusMap)
        vim.schedule(function()
          local nlines = vim.api.nvim_buf_line_count(buf_id)
          local cwd = vim.fs.root(buf_id, '.git')
          local escapedcwd = cwd and vim.pesc(cwd)
          escapedcwd = vim.fs.normalize(escapedcwd)

          for i = 1, nlines do
            local entry = MiniFiles.get_fs_entry(buf_id, i)
            if not entry then
              break
            end
            local relativePath = entry.path:gsub('^' .. escapedcwd .. '/', '')
            local status = gitStatusMap[relativePath]

            if status then
              local symbol, hlGroup = mapSymbols(status, isSymlink(entry.path))
              vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
                sign_text = symbol,
                sign_hl_group = hlGroup,
                priority = 2,
              })
              -- This below code is responsible for coloring the text of the items. comment it out if you don't want that
              local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
              -- Find the name position accounting for potential icons
              local nameStartCol = line:find(vim.pesc(entry.name)) or 0

              if nameStartCol > 0 then
                vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, nameStartCol - 1, {
                  end_col = nameStartCol + #entry.name - 1,
                  hl_group = hlGroup,
                })
              end
            else
            end
          end
        end)
      end

      -- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
      ---@param content string
      ---@return table
      local function parseGitStatus(content)
        local gitStatusMap = {}
        -- lua match is faster than vim.split (in my experience )
        for line in content:gmatch '[^\r\n]+' do
          local status, filePath = string.match(line, '^(..)%s+(.*)')
          -- Split the file path into parts
          local parts = {}
          for part in filePath:gmatch '[^/]+' do
            table.insert(parts, part)
          end
          -- Start with the root directory
          local currentKey = ''
          for i, part in ipairs(parts) do
            if i > 1 then
              -- Concatenate parts with a separator to create a unique key
              currentKey = currentKey .. '/' .. part
            else
              currentKey = part
            end
            -- If it's the last part, it's a file, so add it with its status
            if i == #parts then
              gitStatusMap[currentKey] = status
            else
              -- If it's not the last part, it's a directory. Check if it exists, if not, add it.
              if not gitStatusMap[currentKey] then
                gitStatusMap[currentKey] = status
              end
            end
          end
        end
        return gitStatusMap
      end

      ---@param buf_id integer
      ---@return nil
      local function updateGitStatus(buf_id)
        if not vim.fs.root(buf_id, '.git') then
          return
        end
        local cwd = vim.fs.root(buf_id, '.git')
        -- local cwd = vim.fn.expand("%:p:h")
        local currentTime = os.time()

        if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
          updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
        else
          fetchGitStatus(cwd, function(content)
            local gitStatusMap = parseGitStatus(content)
            gitStatusCache[cwd] = {
              time = currentTime,
              statusMap = gitStatusMap,
            }
            updateMiniWithGit(buf_id, gitStatusMap)
          end)
        end
      end

      ---@return nil
      local function clearCache()
        gitStatusCache = {}
      end

      local function augroup(name)
        return vim.api.nvim_create_augroup('MiniFiles_' .. name, { clear = true })
      end

      autocmd('User', {
        group = augroup 'start',
        pattern = 'MiniFilesExplorerOpen',
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          updateGitStatus(bufnr)
        end,
      })

      autocmd('User', {
        group = augroup 'close',
        pattern = 'MiniFilesExplorerClose',
        callback = function()
          clearCache()
        end,
      })

      autocmd('User', {
        group = augroup 'update',
        pattern = 'MiniFilesBufferUpdate',
        callback = function(args)
          local bufnr = args.data.buf_id
          local cwd = vim.fs.root(bufnr, '.git')
          if gitStatusCache[cwd] then
            updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
          end
        end,
      })

      require('mini.icons').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      require('mini.tabline').setup()

      -- ... and there is more!
      --  Check out: https://github.com/nvim-mini/mini.nvim
    end,
  },
}
-- vim: ts=8 sts=2 sw=2 noet
