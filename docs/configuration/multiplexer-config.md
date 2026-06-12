# Terminal Multiplexer Configuration

## Supported Multiplexers

- **Tmux** — Classic terminal multiplexer
- **Zellij** — Modern terminal workspace

## Tmux

### Key Bindings

| Action | Key |
|--------|-----|
| Prefix | Ctrl+a |
| Split horizontal | prefix + \| |
| Split vertical | prefix + - |
| Navigate panes | Alt+Arrow |
| Vi mode | prefix + [ |

### Plugins (TPM)

- `tmux-resurrect` — Session save/restore
- `tmux-continuum` — Auto-save
- `tmux-sensible` — Better defaults
- `tmux-yank` — System clipboard

### Theme

Tmux auto-detects theme mode:

```bash
if-shell '[ "$DREAMCODER_THEME_MODE" = "light" ]' \
    'source-file ~/.config/tmux/dreamcoder-light.conf' \
    'source-file ~/.config/tmux/dreamcoder-dark.conf'
```

## Zellij

### Key Bindings

| Action | Key |
|--------|-----|
| New tab | Alt+N |
| Next tab | Alt+K |
| Previous tab | Alt+J |
| Go to tab 1-5 | Alt+1-5 |
| Toggle tab | Ctrl+T |

### Layout

Default layout: `dreamcoder` — vertical split with 20% sidebar.
