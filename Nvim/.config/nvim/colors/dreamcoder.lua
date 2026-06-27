-- ========================================================
-- Dreamcoder — auto-detect dispatcher
-- ========================================================
-- Usage: vim.cmd.colorscheme("dreamcoder")
-- Auto-loads the correct variant based on:
--   1. DREAMCODER_THEME_MODE env var
--   2. vim.o.background
--   3. Fallback: dark
-- Direct variant access: colorscheme dreamcoder-dark / dreamcoder-light
-- ========================================================

vim.g.colors_name = "dreamcoder"

-- Glass blur stays dark-only; light needs opaque paper backgrounds for readability.
vim.opt.winblend = 10
vim.opt.pumblend = 10

-- Find variant files relative to this file's location
local src = debug.getinfo(1, "S").source:match("@?(.*)")
local theme_dir = src:match("^(.*[/\\])") or "."

-- Priority: env var → vim.o.background → dark
local mode = vim.env.DREAMCODER_THEME_MODE
if not mode then
  mode = vim.o.background or "dark"
end

if mode == "dark" then
  dofile(theme_dir .. "dreamcoder-dark.lua")
else
  dofile(theme_dir .. "dreamcoder-light.lua")
end
