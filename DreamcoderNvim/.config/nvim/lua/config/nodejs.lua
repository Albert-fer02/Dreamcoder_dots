-- Node.js / JavaScript / TypeScript configuration for Neovim
-- Loaded before LazyVim to ensure LSP and tools are configured

local M = {}

function M.setup(opts)
  opts = opts or {}

  -- Ensure Node.js is available for LSP servers
  if vim.fn.executable("node") == 0 then
    vim.notify("Node.js not found in PATH. LSP servers may not work.", vim.log.levels.WARN)
    return
  end

  -- Configure npm global path
  local npm_global = vim.fn.trim(vim.fn.system("npm root -g 2>/dev/null") or "")
  if npm_global ~= "" and vim.fn.isdirectory(npm_global) == 1 then
    vim.opt.rtp:append(npm_global)
  end

  -- TypeScript-specific settings
  vim.g.markdown_fenced_languages = vim.g.markdown_fenced_languages or {}
  table.insert(vim.g.markdown_fenced_languages, "ts=typescript")
  table.insert(vim.g.markdown_fenced_languages, "tsx=typescriptreact")

  -- Enable modern JavaScript features
  vim.g.did_load_typescript_plugin = 0

  if opts.silent ~= true then
    vim.notify("Node.js config loaded", vim.log.levels.INFO)
  end
end

return M
