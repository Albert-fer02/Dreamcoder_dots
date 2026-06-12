# Migrating from ML4W

## What Changes

- Theme system: Material You → Token-based (Dreamcoder)
- Installer: QML app → Go binary TUI
- Config location: `~/.config/ml4w/` → `~/.config/dreamcoder/`

## Migration Steps

1. Backup ML4W config:
   ```bash
   cp -r ~/.config/ml4w ~/.config/ml4w-backup
   ```

2. Install Dreamcoder:
   ```bash
   brew install dreamcoder08/tap/dreamcoder-dots
   ```

3. Run installer:
   ```bash
   dreamcoder-dots
   ```

4. Select components to migrate

5. Remove ML4W when satisfied:
   ```bash
   rm -rf ~/.config/ml4w
   ```

## Preserved Settings

- Shell aliases and functions
- Neovim keymaps (mostly compatible)
- Git config (stays in `~/.gitconfig`)

## Differences

| Feature | ML4W | Dreamcoder |
|---------|------|------------|
| Theme source | Wallpaper (Material You) | tokens.json |
| Day/Night | Manual | Systemd timer |
| Health checks | None | WCAG/APCA |
