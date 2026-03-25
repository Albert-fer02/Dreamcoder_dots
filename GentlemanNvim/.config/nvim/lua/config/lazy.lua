local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    
    -- Dreamcoder Web Dev Stack
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    
    -- Formatting & Linting
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    
    -- Performance & UI
    { import = "lazyvim.plugins.extras.coding.blink" }, -- Faster completion than cmp
    { import = "lazyvim.plugins.extras.editor.fzf" },   -- Faster fuzzy finder
    { import = "lazyvim.plugins.extras.ui.mini-animate" },

    -- Import user plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, 
  },
  checker = { enabled = true }, 
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})