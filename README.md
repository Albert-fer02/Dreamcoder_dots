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
./scripts/install.sh              # first install / full reapply
./scripts/repair.sh               # after ML4W or Gentleman updates
./scripts/doctor.sh               # inspect current health/status
./scripts/verify.sh               # symlinks + starship + theme health
./scripts/theme-auto.sh           # apply light/dark for current time
./scripts/auto-colors.sh          # refresh from current wallpaper
./scripts/set-wallpaper.sh <file> # set wallpaper and refresh Dreamcoder
```

## Installation

```bash
git clone git@github.com:Dreamcoder08/Dreamcoder_dots.git ~/Documents/PROYECTOS/dreamcoder-dots
cd ~/Documents/PROYECTOS/dreamcoder-dots
./scripts/install.sh
```

`install.sh` stows the Dreamcoder modules, installs ML4W/Waypaper hooks, enables the day/night timer, applies the current mode, and verifies the setup.

## Post-update repair

After updating ML4W, Gentleman Dots, Waypaper, or Hyprland configs, run:

```bash
cd ~/Documents/PROYECTOS/dreamcoder-dots
./scripts/repair.sh
```

This reapplies hooks, restows modules, restarts the timer, refreshes the current theme, and runs verification.

## Theme system

- **Day**: warm light mode, paper-like surfaces, dark graphite text.
- **Night**: softened graphite mode, warm text, lower glare than pure black.
- **Wallpaper adaptive**: wallpaper colors can tint accents, but contrast guardrails stay mandatory.
- **opencode/Codex**: `dreamcoder.json` and `gentleman-dreamcoder-legible.json` are generated together.

Important files:

```txt
scripts/sync-dreamcoder-theme.py     # generator for terminals/opencode/overlays
scripts/theme-auto.sh                # time-based light/dark orchestrator
scripts/wallpaper-hook.sh            # robust wallpaper + Dreamcoder refresh hook
scripts/verify-theme-health.py       # contrast and eye-comfort guardrails
Systemd/.config/systemd/user/*       # day/night user timer
```

## Visual health policy

Dreamcoder prioritizes long-session comfort over trendy contrast extremes:

- no pure black or pure white as primary backgrounds;
- warm off-white light mode to reduce glare;
- softened dark mode instead of harsh black/white inversion;
- AAA-level main text contrast where practical;
- AA-or-better semantic token contrast for code, markdown, and diffs;
- typography and spacing tuned for fewer micro-adjustments.

## Troubleshooting

```bash
./scripts/doctor.sh
```

Common fixes:

- **Looks dark during the day**: run `./scripts/theme-auto.sh`; check GTK in `doctor.sh`.
- **Wallpaper with spaces does not load**: use `./scripts/set-wallpaper.sh <file>` or re-run `./scripts/repair.sh`.
- **ML4W update overwrote hooks**: run `./scripts/repair.sh`.
- **opencode theme looks old**: ensure `~/.config/opencode/tui.json` uses `gentleman-dreamcoder-legible`, then run `./scripts/theme-auto.sh`.
- **Theme feels too intense**: run `DREAMCODER_ADAPTIVE=0 ./scripts/theme-auto.sh` to disable wallpaper tinting for that run.

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
./scripts/verify.sh
./scripts/verify-theme-health.py
```

A healthy setup should report linked configs, valid Starship, active timer, and passing visual-health guardrails.
