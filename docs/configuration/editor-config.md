# Editor Configuration

## Neovim (LazyVim)

### Structure

```
Nvim/.config/nvim/
├── init.lua           # Bootstrap
├── lua/
│   ├── config/        # Core config
│   ├── plugins/       # Plugin specs
│   └── colors/        # Dreamcoder colorscheme
```

### Theme

Dreamcoder colorscheme generated from `tokens.json`:

```lua
-- lua/plugins/colorscheme.lua
return {
  "dreamcoder.nvim",
  opts = {
    variant = "dark", -- or "light" or "dusk"
  },
}
```

### Key Maps

See `docs/neovim-keymaps.md` for complete reference.

### Plugins

Core plugins:
- LazyVim (framework)
- LSP (nvim-lspconfig)
- Treesitter (syntax)
- Telescope (fuzzy finder)
- Git signs
- Which-key (key hints)
