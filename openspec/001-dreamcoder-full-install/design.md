# Design: Full Installation Integration

> **SDD Change:** `001-dreamcoder-full-install`

## Architecture

### Data Flow: Mode Switching

```
dreamcoder dark/light (CLI)
    │
    ▼
apply-theme-mode.sh
    │
    ├── 1. Set DREAMCODER_THEME_MODE env
    ├── 2. Flips symlinks:
    │       Waybar: colors.css → colors-{mode}.css
    │       Rofi:   colors.rasi → colors-{mode}.rasi
    │       Hypr:   colors.lua → colors-{mode}.lua
    │       Hypr:   colors.conf → colors-{mode}.conf
    │       Dunst:  dreamcoder-dunst.conf (sync writes to it)
    │
    ├── 3. Run matugen (wallpaper colors)
    ├── 4. Run sync-dreamcoder-theme.py (writes ALL theme files)
    │       ├── Kitty: colors-dreamcoder-{mode}.conf
    │       ├── Ghostty: theme file (mode-tracked)
    │       ├── Starship: env var only (DREAMCODER_THEME_MODE)
    │       ├── Tmux: tmux-dreamcoder.conf (via kanagawa plugin)
    │       ├── Fish: sources via 05-dreamcoder-theme.fish
    │       ├── Btop: writes dreamcoder.theme (NEW)
    │       ├── Bat: writes .tmTheme files (already exists)
    │       └── ...
    │
    ├── 5. Restart Waybar
    ├── 6. Update tmux environment + kanagawa theme
    └── 7. Restart Kitty (SIGUSR1)
```

### Data Flow: Installation

```
./scripts/install.sh
    │
    ├── 0. Preflight: check prerequisites (git, stow, python3)
    ├── 1. Backup manifest: save current state of target paths
    ├── 2. Detect GENTLEMAN_DOTS_DIR (env var, known paths, user input)
    ├── 3. Set GENTLEMAN_DOTS_DIR in fish conf.d/00-gentleman-dots-path.fish
    ├── 4. Create symlinks for:
    │       ├── Ghostty config
    │       ├── Kitty config
    │       ├── Tmux config
    │       ├── Fish theme contract
    │       ├── Starship config
    │       ├── Zellij config
    │       ├── Nvim colorscheme
    │       └── Fastfetch config
    ├── 5. Deploy theme files:
    │       ├── Btop theme → ~/.config/btop/themes/dreamcoder.theme
    │       ├── Bat theme → ~/.config/bat/themes/
    │       └── Dunst theme → ~/.config/dunst/dreamcoder-dunst.conf
    ├── 6. Install Hyprland hook:
    │       ├── Write dreamcoder-colors.conf import in hyprland.lua
    │       └── Conditional: [ -f ~/.config/hypr/dreamcoder-colors.conf ]
    ├── 7. Run dreamcoder-theme sync
    ├── 8. Enable systemd timer: dreamcoder-theme-auto.timer
    ├── 9. Print rollback command
    └── 10. Run verification
```

### Data Flow: Doctor

```
dreamcoder doctor
    │
    ├── Structured health (Python control center):
    │       ├── doctor.py → JSON report
    │       └── doctor.sh → Human-readable report
    │
    ├── Checks organized by layer:
    │
    ├── Layer 1: Gentleman.Dots hooks
    │   ├── Ghostty:    theme file exists, config references it
    │   ├── Kitty:      colors-dreamcoder.conf exist, kitty.conf includes
    │   ├── Tmux:       tmux-dreamcoder.conf exists, kanagawa plugin
    │   ├── Nvim:       colors/dreamcoder.lua exists, colorscheme("dreamcoder") works
    │   ├── Fish:       05-dreamcoder-theme.fish sources correctly
    │   ├── Starship:   config exists, palette valid
    │   └── Zellij:     theme file exists, config references it
    │
    ├── Layer 2: ML4W hooks
    │   ├── Hyprland:   colors.lua/colors.conf symlinks ok, dreamcoder-colors.conf imported
    │   ├── Waybar:     colors.css symlink correct, @import works
    │   ├── Rofi:       colors.rasi symlink correct, @theme works
    │   ├── Dunst:      dreamcoder-dunst.conf symlinked, include works
    │   ├── Btop:       theme file exists, btop.conf references it
    │   └── GTK:        color-scheme matches dreamcoder mode
    │
    ├── Layer 3: Dreamcoder features
    │   ├── Auto-theme timer: enabled and active
    │   ├── Pi theme:        dreamcoder.json exists
    │   ├── OpenCode:        theme = dreamcoder
    │   ├── Warp:            theme file exists
    │   ├── Bat:             .tmTheme files exist
    │   ├── Firefox:         css exists (optional)
    │   ├── Obsidian:        css exists (optional)
    │   └── Cava:            config exists (optional)
    │
    └── Output:
        ├── --json: machine-readable {status, components: [{name, status, detail, repair}]}
        └── default: human-readable with ✓/✗/⚠ and suggested commands
```

## Component Design

### 1. Btop Theme Deployment

**Current state**: `DreamcoderThemes/btop-dreamcoder.theme` exists but not deployed.

**Solution**: Add a `deploy_btop_theme()` function in `sync.py` / `repair_engine.py`:

- Write the theme file from repo to `~/.config/btop/themes/dreamcoder.theme`
- Set `color_theme = "dreamcoder"` in `btop.conf`
- If btop.conf doesn't exist, skip (ML4W manages it)

**Mode switching**: Only one theme file needed — Btop uses the same colors file and the mode switching is handled by the terminal palette. The theme file should reference dreamcoder token colors.

### 2. Hyprland dreamcoder-colors Import

**Current state**: `dreamcoder-colors.conf` exists at `~/.config/hypr/` but hyprland.lua uses ML4W's `require("colors")`.

**Solution**: Add `require("dreamcoder-colors")` in hyprland.lua after the ML4W colors import. The dreamcoder-colors file overrides specific color variables that matter for the dreamcoder identity.

However, the dreamcoder-colors.conf uses the OLD conf format. ML4W 2.13+ uses LUA format. We need:

- Either convert `dreamcoder-colors.conf` to `dreamcoder-colors.lua` format
- Or add a `source = dreamcoder-colors.conf` in the hyprland.lua

Looking at ML4W's hyprland.lua:

```lua
require("colors")  -- loads colors.lua → colors-light.lua (ML4W)
```

We need to add AFTER that:

```lua
require("dreamcoder-colors")  -- loads dreamcoder-colors.lua (dreamcoder overrides)
```

The `dreamcoder-colors.lua` file should be generated by sync.py and written to `~/.config/hypr/`.

### 3. Installer Idempotency

**Current state**: `install.sh` creates symlinks unconditionally.

**Solution**: Add a backup manifest system:

- Before any write, read existing state and save to `~/.local/share/dreamcoder/backups/{timestamp}/manifest.json`
- Manifest contains: `{path, type: "symlink"|"copy"|"managed_dir", target, timestamp}`
- On re-run: skip paths where manifest matches current state
- On rollback: restore from manifest

Using the existing `dreamcoder_theme/installer.py` which already has `installer plan --json` and backup mechanisms.

### 4. Doctor Extensions

The Python doctor module already has structured health checks. We need to add check functions for each new target:

```python
def check_btop_theme():
    """Check ~/.config/btop/themes/dreamcoder.theme exists and btop.conf references it"""

def check_hypr_dreamcoder_import():
    """Check hyprland.lua has require('dreamcoder-colors')"""

def check_bat_theme():
    """Check ~/.config/bat/themes/Dreamcoder-*.tmTheme exists"""

def check_gtk_colorscheme():
    """Check gsettings color-scheme matches DREAMCODER_THEME_MODE"""

def check_firefox_theme():
    """Check ~/.mozilla/firefox/*/chrome/dreamcoder.css exists"""

def check_obsidian_theme():
    """Check ~/.config/obsidian/dreamcoder.css exists"""

def check_cava_config():
    """Check ~/.config/cava/dreamcoder.config exists"""

def check_auto_timer():
    """Check systemctl --user is-enabled dreamcoder-theme-auto.timer"""

def check_backup_freshness():
    """Check latest backup manifest is recent enough"""
```

### 5. CI Integration Test

Docker-based test that:

1. Starts from a clean Arch Linux container
2. Installs Gentleman.Dots via direct download
3. Installs ML4W via curl | bash
4. Clones dreamcoder-dots
5. Runs `./scripts/install.sh`
6. Runs `dreamcoder doctor --json` and verifies all checks pass
7. Runs `dreamcoder light` then `dreamcoder dark` and verifies files change

Since Docker may not be available in GitHub Actions for Arch, use a matrix:

- Option A: Native GitHub Actions runner on Ubuntu, test just the overlay (skip full ML4W/Gentleman install)
- Option B: Use `archlinux/archlinux:latest` Docker container

Alternative: Use the testing capability registered in openspec/config.yaml if any.

## File Changes

| # | File | Change | Risk |
|---|------|--------|------|
| T1 | (working tree) | Commit/stash existing changes | 🟢 Low |
| T2 | `DreamcoderThemes/dreamcoder/hypr-colors-{mode}.lua` | Generate lua variant | 🟢 Low |
| T2 | scripts/apply-theme-mode.sh | Add hyprland dreamcoder-colors.lua write | 🟢 Low |
| T3 | src/dreamcoder_theme/sync.py | Add btop theme deployment | 🟢 Low |
| T3 | scripts/install.sh | Deploy btop theme | 🟢 Low |
| T4 | scripts/install.sh | Add timer enable | 🟢 Low |
| T5 | src/dreamcoder_theme/doctor.py | Add 8 new check functions | 🟡 Medium |
| T5 | scripts/doctor.sh | Call new checks | 🟢 Low |
| T6 | scripts/install.sh | Add backup manifest + rollback | 🟡 Medium |
| T7 | src/dreamcoder_theme/repair_engine.py | Extend catalog | 🟢 Low |
| T8 | .github/workflows/integration-test.yml | Create workflow | 🟡 Medium |
| T9 | scripts/verify.sh | Add waybar @import check | 🟢 Low |
| T10 | docs/installation/linux.md | Full rewrite | 🟢 Low |

## Testing Strategy

- **T2-T4**: Manual verification on the actual system (we can run `dreamcoder doctor` and check)
- **T5**: Unit tests for new doctor check functions
- **T6**: Manual idempotency test (run install.sh 3 times)
- **T7**: Unit tests for new repair catalog entries
- **T8**: CI workflow — test by pushing a branch
- **T9-T10**: Manual verification + doc review

## Rollback Plan

If something goes wrong:

```bash
# Full rollback
~/.local/share/dreamcoder/backups/{latest}/rollback.sh
```

Or per-component:

```bash
# Remove btop theme
rm ~/.config/btop/themes/dreamcoder.theme
# Restore btop.conf
# Reverse hyprland.lua changes
git checkout -- ~/.config/hypr/hyprland.lua
# Disable timer
systemctl --user disable --now dreamcoder-theme-auto.timer
```
