-- Dreamcoder Preference: High Legibility & Modern UX
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus" -- System clipboard
vim.opt.cursorline = true
vim.opt.scrolloff = 8 -- Keep 8 lines context when scrolling

-- Disable swap files (modern machines don't need this mostly)
vim.opt.swapfile = false

-- Search optimization
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
