-- lua/user/core/options.lua

local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true         -- shows absolute line number on cursor line (when relative is on)

-- tabs & indentation
opt.tabstop = 2      -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2   -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

-- appearance
opt.termguicolors = true -- enable 24-bit RGB colors
opt.cursorline = true    -- highlight the current line
opt.signcolumn = "yes"   -- always show the sign column, otherwise it would shift the text

-- behavior
opt.splitright = true    -- split vertical window to the right
opt.splitbelow = true    -- split horizontal window to the bottom
opt.mouse = "a"          -- enable mouse support
opt.clipboard = "unnamedplus" -- use system clipboard
opt.undofile = true      -- save undo history
opt.swapfile = false     -- don't use swapfile
opt.backup = false       -- don't create backup file
opt.showmode = false     -- we have a statusline, so we don't need this
opt.scrolloff = 8        -- minimal number of screen lines to keep above and below the cursor

