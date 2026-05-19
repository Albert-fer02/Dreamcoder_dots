# DreamcoderDots

Personal Arch Linux dotfiles for the **Dreamcoder** identity.

Dreamcoder uses one identity with two visual contexts:

- **Dreamcoder Environment**: Warp-like dark glass, OpenAI/Codex-like light UI, ML4W/Gentleman-compatible snippets.
- **Dreamcoder Prompt**: Cocoa/Lúcuma warmth, ivory text, vivid lúcuma focus, cyan diagnostics.

Wallpaper tools may change generated colors, but the Dreamcoder identity should be reapplied from this repo.

## Visual health policy

Dreamcoder prioritizes long-session comfort over trendy contrast extremes:

- no pure black or pure white as primary backgrounds;
- warm off-white light mode to reduce glare;
- softened dark mode instead of harsh black/white inversion;
- AAA-level main text contrast where practical;
- AA-or-better semantic token contrast for code, markdown, and diffs;
- wallpaper adaptation may tint accents, but cannot bypass contrast guardrails.

Run the guardrail check with:

```bash
./scripts/verify-theme-health.py
```

## Identity

### Active dark mode

```txt
terminal bg   #0b0c0e
terminal text #f1eee7
prompt cocoa  #19120c / #2a1d13 / #402c18
prompt lucuma #fbb974
cyan diag     #9ecad0
error coral   #d98a7a
opacity       0.60
```

### Light mode reference

```txt
ui bg         #fbfaf7
ui surface    #ffffff
ui text       #0b0c0e
prompt cocoa  #fff7e8 / #e4caa7
prompt copper #a35f29
cyan diag     #176875
```

## Structure

```txt
dreamcoder-dots/
├── Shell/       # Bash, Zsh, Fish, Starship dark/light
├── Kitty/       # Kitty config and Dreamcoder dark/light colors
├── Ghostty/     # Ghostty config and Dreamcoder dark/light themes
├── Warp/        # Warp Terminal themes
├── Fastfetch/   # Fastfetch config and Dreamcoder image
├── Codex-App/   # Codex/opencode-style theme exports
├── themes/      # Portable ML4W/Gentleman color-only snippets
└── scripts/     # Sync and utility scripts
```

## Install with stow

```bash
./scripts/install.sh
```

Run this again after installing or updating ML4W/Gentleman Dots. It restows
Dreamcoder, re-enables the day/night timer, reapplies the current mode, and
reinstalls the Waypaper/ML4W wallpaper hooks so Dreamcoder remains the final
theme layer.

`Codex-App/` is kept as an import/export artifact, not stowed into `$HOME` by default.

## Apply active dark identity

```bash
./scripts/sync-dreamcoder-theme.py
```

This writes/regenerates:

- `Kitty/.config/kitty/colors-dreamcoder.conf`
- `Ghostty/.config/ghostty/themes/dreamcoder`
- `Warp/.local/share/warp-terminal/themes/Dreamcoder.yaml`
- `Shell/.config/starship.toml`
- `Codex-App/Dreamcoder.codex-theme.json`

## Generate light identity

```bash
DREAMCODER_THEME_MODE=light ./scripts/sync-dreamcoder-theme.py
```

## Adaptive wallpaper accents

Pass the current wallpaper to keep the readable light/dark base while adapting
accent, selection, border, and prompt warmth to the image:

```bash
DREAMCODER_THEME_MODE=light DREAMCODER_WALLPAPER="$wallpaper" ./scripts/sync-dreamcoder-theme.py
```

`DREAMCODER_ADAPTIVE=0` disables wallpaper adaptation. The main foreground and
background stay contrast-guarded so the wallpaper cannot make the terminal
illegible.

Light variants are also stored in the repo:

- `Kitty/.config/kitty/colors-dreamcoder-dark.conf`
- `Kitty/.config/kitty/colors-dreamcoder-light.conf`
- `Ghostty/.config/ghostty/themes/dreamcoder-dark`
- `Ghostty/.config/ghostty/themes/dreamcoder-light`
- `Warp/.local/share/warp-terminal/themes/Dreamcoder-Dark.yaml`
- `Warp/.local/share/warp-terminal/themes/Dreamcoder-Light.yaml`
- `Shell/.config/starship-dark.toml`
- `Shell/.config/starship-light.toml`
- `Codex-App/Dreamcoder-Dark.codex-theme.json`
- `Codex-App/Dreamcoder-Light.codex-theme.json`

## ML4W / Gentleman Dots integration

Use `themes/dreamcoder/` as color-only overlays after your existing ML4W/Gentleman files:

- `themes/dreamcoder/hyprland-dark.conf`
- `themes/dreamcoder/hyprland-light.conf`
- `themes/dreamcoder/waybar-dark.css`
- `themes/dreamcoder/waybar-light.css`
- `themes/dreamcoder/rofi-dark.rasi`
- `themes/dreamcoder/rofi-light.rasi`

Do not move keybinds, layouts, wallpaper automation, gaps, or animation logic into these snippets.

## Automatic day/night mode

Dreamcoder can switch by local time automatically:

```bash
cd ~/.dotfiles
systemctl --user daemon-reload
systemctl --user enable --now dreamcoder-theme-auto.timer
```

Defaults:

```txt
light: 07:00–17:59
dark:  18:00–06:59
```

The automation also updates GTK/GNOME color preference so apps see
`prefer-light` during the day and `prefer-dark` at night.

For Waypaper/ML4W wallpaper changes, use the Dreamcoder hook after the ML4W
wallpaper script:

```ini
post_command = ~/.config/hypr/scripts/wallpaper.sh "$wallpaper" > /dev/null 2>&1; ~/.dotfiles/scripts/wallpaper-hook.sh "$wallpaper" > /dev/null 2>&1
```

The hook creates a safe cache symlink for wallpaper paths with spaces, applies
Hyprpaper per monitor, then refreshes Dreamcoder light/dark/adaptive colors.

Override hours if needed:

```bash
systemctl --user edit dreamcoder-theme-auto.service
```

Then add:

```ini
[Service]
Environment=DREAMCODER_LIGHT_START=8
Environment=DREAMCODER_DARK_START=19
```

## Verify

```bash
STARSHIP_CONFIG="Shell/.config/starship.toml" starship explain
STARSHIP_CONFIG="Shell/.config/starship-light.toml" starship explain
git diff --check
```

## Rules

- Public identity stays **Dreamcoder**.
- Prompt keeps Cocoa/Lúcuma warmth.
- Desktop/terminal can use Dreamcoder glass.
- Scripts should stay small, quoted, safe, and portable.
- Do not commit secrets or machine-local tokens.
