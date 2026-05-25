# Dreamcoder OS

Personal Arch Linux dotfiles for the **Dreamcoder** identity: a visual layer on top of ML4W/Gentleman Dots focused on readability, eye comfort, and a premium coding experience.

## Philosophy

Dreamcoder is not a neon rice. It is a workbench:

- **health first**: no pure black/white primary backgrounds, strong contrast, low glare;
- **daily comfort**: larger terminal type, calmer prompt density, automatic day/night mode;
- **identity second**: Cocoa/Lúcuma warmth, diagnostic cyan, restrained editorial colors;
- **ML4W-compatible**: Dreamcoder owns colors and hooks, ML4W/Gentleman can keep layout behavior.

## Quick commands

```bash
./scripts/dreamcoder install      # first install / full reapply
./scripts/dreamcoder repair       # after ML4W or Gentleman updates
./scripts/dreamcoder doctor       # inspect current health/status
./scripts/dreamcoder verify       # symlinks + starship + theme health
./scripts/dreamcoder preview      # regenerate docs/dreamcoder-theme-preview.md
./scripts/dreamcoder auto         # apply light/dark for current time
./scripts/dreamcoder light        # force light mode
./scripts/dreamcoder dusk         # force dusk transitional mode
./scripts/dreamcoder dark         # force dark mode
./scripts/set-wallpaper.sh <file> # set wallpaper and refresh Dreamcoder
```

## Installation

```bash
git clone git@github.com:Dreamcoder08/Dreamcoder_dots.git ~/Documents/PROYECTOS/dreamcoder-dots
cd ~/Documents/PROYECTOS/dreamcoder-dots
./scripts/dreamcoder install
```

`install.sh` stows the Dreamcoder modules, installs ML4W/Waypaper hooks, enables the day/night timer, applies the current mode, and verifies the setup.

## Post-update repair

After updating ML4W, Gentleman Dots, Waypaper, or Hyprland configs, run:

```bash
cd ~/Documents/PROYECTOS/dreamcoder-dots
./scripts/dreamcoder repair
```

This reapplies hooks, restows modules, restarts the timer, refreshes the current theme, and runs verification.

## Theme system

- **Day** (`light`): warm paper surfaces, flat surface ladder, distinct semantic tokens.
- **Dusk** (`dusk`): transitional warmth (default 16:00–18:00) before night mode.
- **Night** (`dark`): softened graphite mode, warm text, lower glare than pure black.
- **Wallpaper adaptive**: wallpaper colors can tint accents, but contrast guardrails stay mandatory.
- **UI affordances**: focus and meaningful borders use dedicated 3:1+ tokens; decorative borders stay subtle.
- **opencode/Codex/PI CLI**: `dreamcoder.json` is generated and selected globally; stale opencode theme JSONs are removed by the sync script.

Important files:

```txt
themes/dreamcoder/tokens.json        # canonical design tokens: colors + guardrails
themes/dreamcoder/tokens.schema.json # schema for the token contract
scripts/dreamcoder                   # unified CLI entrypoint
scripts/sync-dreamcoder-theme.py     # generator for terminals/opencode/overlays
scripts/theme-auto.sh                # time-based light/dusk/dark selector
scripts/apply-theme-mode.sh          # shared mode applier for auto and manual modes
scripts/wallpaper-hook.sh            # robust wallpaper + Dreamcoder refresh hook
scripts/verify-theme-health.py       # contrast and eye-comfort guardrails
scripts/generate-theme-preview.py     # Markdown palette/contrast preview
Systemd/.config/systemd/user/*       # day/night user timer
```

## Design-token architecture

Dreamcoder has one canonical palette contract: `themes/dreamcoder/tokens.json`. The generator reads these tokens first, then emits terminal, Codex/opencode, Waybar, Rofi, Hyprland, and prompt outputs. This keeps the system coherent after ML4W/Gentleman updates and prevents each app from drifting into a different palette.

The token file includes hard guardrails: canonical opencode theme `dreamcoder`, no harsh pure black/white primary backgrounds, WCAG AA minimum token contrast, AAA target for main text, and APCA Lc checks for body and UI tokens.

See the auditable palette gallery: [docs/dreamcoder-theme-preview.md](docs/dreamcoder-theme-preview.md).

## Design rationale (light)

Dreamcoder light themes are **identity-first**, not wallpaper-derived:

- **Cocoa/lúcuma warmth**: parchment backgrounds (`#f6f1e8`), graphite-brown text, gold accent and terracotta secondary (hue-separated, not just darker gold).
- **Flat surface ladder**: `surface0` → `surface2` moves in small luminance steps so panels layer without muddy mid-tones.
- **Distinct semantics**: `comment` ≠ `subtle`, `focus` (teal) ≠ `diagnostic` (ink blue), `border_ui` ≠ `border_hi`.
- **Dusk bridge**: warm intermediate palette for late afternoon before dark mode.

Top light themes (Catppuccin Latte, Rosé Pine Dawn, etc.) share these patterns; Dreamcoder adds a named philosophy and token-level enforcement in `verify-theme-health.py`.

## Visual health policy

Dreamcoder prioritizes long-session comfort over trendy contrast extremes:

- no pure black or pure white as primary backgrounds;
- warm off-white light mode to reduce glare;
- softened dark mode instead of harsh black/white inversion;
- AAA-level main text contrast where practical (WCAG 2);
- APCA Lc ≥ 75 for body tokens and ≥ 60 for UI affordances on light/dusk backgrounds;
- AA-or-better semantic token contrast for code, markdown, and diffs;
- 3:1+ contrast for meaningful focus rings and UI boundaries;
- typography and spacing tuned for fewer micro-adjustments.

## Troubleshooting

```bash
./scripts/dreamcoder doctor
```

Common fixes:

- **Looks dark during the day**: run `./scripts/dreamcoder auto`; check GTK in `doctor.sh`.
- **Wallpaper with spaces does not load**: use `./scripts/set-wallpaper.sh <file>` or re-run `./scripts/dreamcoder repair`.
- **ML4W update overwrote hooks**: run `./scripts/dreamcoder repair`.
- **opencode theme looks old**: ensure `~/.config/opencode/tui.json` uses `dreamcoder`, then run `./scripts/dreamcoder auto`.
- **Theme feels too intense**: run `DREAMCODER_ADAPTIVE=0 ./scripts/dreamcoder auto` to disable wallpaper tinting for that run.
- **Shell startup feels noisy**: set `DREAMCODER_FASTFETCH_ON_START=1` only when you want Fastfetch on new Zsh shells.

## Structure

```txt
Shell/       Starship and shell ergonomics
Kitty/       Kitty config and Dreamcoder colors
Ghostty/     Ghostty config and Dreamcoder theme
Warp/        Warp Terminal themes
Fastfetch/   Fastfetch config
Codex-App/   Codex/opencode theme exports
themes/      ML4W/Gentleman portable color overlays
scripts/     install, repair, doctor, theme, wallpaper, verification
Systemd/     user timer/service for automatic day/night mode
```

## Verification

```bash
./scripts/dreamcoder verify
./scripts/verify-theme-health.py
```

A healthy setup should report linked configs, valid Starship, active timer, and passing visual-health guardrails. Use `./scripts/dreamcoder preview` after palette edits to refresh the auditable preview gallery.
