# Shell Configuration

## Supported Shells

- **Fish** — Default shell, friendly interactive shell
- **Zsh** — Z shell with Oh My Zsh
- **Nushell** — Modern structured shell

## Theme Integration

Each shell config sources Dreamcoder Workbench themes based on `DREAMCODER_THEME_MODE`:

```bash
# In .zshrc
source ~/.config/shell/fzf-dreamcoder-${DREAMCODER_THEME_MODE}.sh
source ~/.config/shell/ls-colors-dreamcoder-${DREAMCODER_THEME_MODE}.sh
```

## Aliases

Common aliases across all shells:

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shortcut |
| `gs` | `git status` | Git status |
| `gp` | `git push` | Git push |
| `ll` | `ls -la` | Long listing |
| `cat` | `bat` | Syntax highlighting |
| `find` | `fd` | Find files |
| `grep` | `rg` | Ripgrep |
