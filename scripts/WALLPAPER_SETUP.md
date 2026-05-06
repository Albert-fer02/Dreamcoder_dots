# Wallpaper and Dreamcoder identity

Dreamcoder now uses a **fixed identity palette**. Wallpaper changes should not
change the main terminal colors.

## Goal

When ML4W/Matugen changes the wallpaper, Dreamcoder should reapply the official
palette afterward:

```txt
background  #19120c
foreground  #eee0d5
accent      #fbb974
```

## Hook

Your ML4W wallpaper hook should call this after Matugen:

```bash
~/.dotfiles/scripts/sync-dreamcoder-theme.py
```

The current live hook is expected around:

```txt
~/.config/hypr/scripts/wallpaper.sh
```

and should contain:

```sh
if [ -x "$HOME/.dotfiles/scripts/sync-dreamcoder-theme.py" ]; then
    DREAMCODER_WALLPAPER="$used_wallpaper" "$HOME/.dotfiles/scripts/sync-dreamcoder-theme.py"
fi
```

`DREAMCODER_WALLPAPER` is accepted for hook compatibility, but the sync script
keeps the palette fixed.

## Manual apply

```bash
~/.dotfiles/scripts/sync-dreamcoder-theme.py
```

## Reload behavior

Kitty:

```bash
pkill -SIGUSR1 kitty
```

Ghostty:

```txt
Ctrl + Shift + R
```

Ghostty 1.3.1 supports `reload_config` as an action/keybind, not a simple
`SIGUSR1` reload like Kitty.
