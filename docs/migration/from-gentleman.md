# Migrating from Gentleman.Dots

## What Changes

- AI layer: Separate (gentle-ai) → Separate (dreamcoder-ai)
- Installer: Go binary → Go binary (different TUI)
- Shell: Same (Fish/Zsh) + Nushell added

## Migration Steps

1. Backup Gentleman config:
   ```bash
   cp -r ~/.config/gentleman ~/.config/gentleman-backup
   ```

2. Install Dreamcoder:
   ```bash
   brew install dreamcoder08/tap/dreamcoder-dots
   ```

3. Run installer:
   ```bash
   dreamcoder-dots
   ```

4. For AI layer:
   ```bash
   brew install dreamcoder08/tap/dreamcoder-ai
   ```

5. Remove Gentleman when satisfied:
   ```bash
   rm -rf ~/.config/gentleman
   ```

## Preserved Settings

- Fish shell config (compatible)
- Neovim LazyVim (compatible)
- Tmux config (compatible)
- Ghostty config (similar structure)

## Differences

| Feature | Gentleman | Dreamcoder |
|---------|-----------|------------|
| Theme | Hardcoded | Token-based |
| AI layer | gentle-ai | dreamcoder-ai |
| Vim trainer | ✅ | ✅ (improved) |
| Day/Night | ❌ | ✅ Systemd timer |
| Health checks | ❌ | ✅ WCAG/APCA |
