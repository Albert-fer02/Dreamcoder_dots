-- ========================================================
-- Dreamcoder — auto-detect dispatcher
-- ========================================================
-- Usage: vim.cmd.colorscheme("dreamcoder")
-- Auto-loads the correct variant based on vim.o.background.
-- Direct variant access: colorscheme dreamcoder-dark / dreamcoder-light / dreamcoder-dusk
-- ========================================================

vim.g.colors_name = "dreamcoder"

-- Glass blur stays dark-only; light needs opaque paper backgrounds for readability.
vim.opt.winblend = 10
vim.opt.pumblend = 10

-- Find variant files relative to this file's location
local src = debug.getinfo(1, "S").source:match("@?(.*)")
local theme_dir = src:match("^(.*[/\\])") or "."

local bg = vim.o.background or "dark"

if bg == "dark" then
  dofile(theme_dir .. "dreamcoder-dark.lua")
else
  dofile(theme_dir .. "dreamcoder-light.lua")
end
