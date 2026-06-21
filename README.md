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


## Dreamcoder Control Center

Dreamcoder now exposes a structured control layer behind the existing CLI. This is the foundation for a future TUI/GUI settings app and gives scripts a stable JSON contract instead of scraping terminal output.

```bash
./scripts/dreamcoder dashboard --markdown
./scripts/dreamcoder dashboard --json
./scripts/dreamcoder tui render
./scripts/dreamcoder tui render --json
./scripts/dreamcoder tui set terminal.default_mode light --dry-run --json
./scripts/dreamcoder docs report --markdown
./scripts/dreamcoder docs report --write --json
./scripts/dreamcoder audit compare --markdown
./scripts/dreamcoder audit compare --json
./scripts/dreamcoder visual plan --markdown
./scripts/dreamcoder visual plan --json
./scripts/dreamcoder visual audit --json
./scripts/dreamcoder doctor-json
./scripts/dreamcoder settings schema --json
./scripts/dreamcoder settings validate --json
./scripts/dreamcoder profile list --json
./scripts/dreamcoder profile apply asus-vivobook15 --dry-run --json
./scripts/dreamcoder motion list --json
./scripts/dreamcoder motion apply fluid --dry-run --json
./scripts/dreamcoder settings set terminal.default_mode light
./scripts/dreamcoder settings get terminal.default_mode --json
./scripts/dreamcoder repair catalog --json
./scripts/dreamcoder repair plan --json
./scripts/dreamcoder repair apply --dry-run --json
./scripts/dreamcoder backup list --json
./scripts/dreamcoder backup restore <backup-id> --dry-run --json
```

See `docs/DREAMCODER_CONTROL_CENTER.md` for the operator dashboard, safety model, and visual command map. `visual plan` defines screenshot targets and `visual audit` checks sources, baselines, and runtime contracts for Neovim, terminals, Waybar, Rofi, Codex CLI, and opencode.

The first built-in machine profiles are `default` and `asus-vivobook15`. Motion presets are `battery`, `balanced`, `fluid`, and `cinematic`; each preset declares its terminal cursor behavior, Hyprland animation intent, and performance cost.

`doctor-json` emits `dreamcoder.doctor.v1` checks with `name`, `status`, `detail`, and `repair`, making health issues actionable and testable.

`repair plan` emits `dreamcoder.repair-plan.v1` and separates safe automatic fixes from manual actions. `repair apply` only applies safe repairs and creates a backup manifest first.

Profile and motion applies create `dreamcoder.backup.v1` manifests under `$XDG_DATA_HOME/dreamcoder/backups`, so risky changes can be inspected and rolled back instead of blindly overwritten.

## Theme system

Dreamcoder themes are **generated from one canonical token set** (`themes/dreamcoder/tokens.json`) and rendered into **22 targets** — spanning terminals, editors, shell tooling, desktop UI, and even browser/note apps.

- **Day** (`light`): warm paper surfaces, flat surface ladder, distinct semantic tokens.
- **Dusk** (`dusk`): transitional warmth (default 16:00–18:00) before night mode.
- **Night** (`dark`): Ember Noir — espresso/cacao glass with semi-transparent backgrounds, warm silver text, refined orange and maple red protagonists, gold support accent.
- **Wallpaper adaptive**: wallpaper colors can tint accents, but contrast guardrails stay mandatory.
- **UI affordances**: focus and meaningful borders use dedicated 3:1+ tokens; decorative borders stay subtle.
- **Neovim glass blur**: the Neovim theme uses `none` backgrounds for main groups so terminal transparency and blur show through; panels and selections carry the autumn glass color.
- **One source of truth**: `sync-dreamcoder-theme.py` reads `tokens.json`, renders all targets, and the `dreamcoder` CLI applies modes or regenerates selectively.

### 22 theme targets

| Target | Files | How it wires up |
|--------|-------|-----------------|
| **Kitty** | `kitty-dreamcoder-{mode}.conf` | `include` in kitty.conf |
| **Ghostty** | `ghostty-dreamcoder-{mode}` | `theme = dreamcoder-{mode}` |
| **Warp** | `Warp/.../Dreamcoder-{Mode}.yaml` | Warp theme picker |
| **Hyprland** | `hyprland-{mode}.conf`, `colors.lua`, `colors.conf` | `source` from hyprland.conf; colors written to `~/.config/hypr/` |
| **Waybar** | `waybar-{mode}.css`, `colors.css` | `@import` in waybar style.css; colors written to `~/.config/waybar/` |
| **Rofi** | `rofi-{mode}.rasi`, `colors.rasi` | `@import` or `-theme` in rofi launch; colors written to `~/.config/rofi/` |
| **Starship** | `starship-{mode}.toml` | `STARSHIP_CONFIG` env var |
| **Antigravity** | `Antigravity/Dreamcoder-{Mode}.json` | Antigravity theme selector |
| **opencode** | `opencode/dreamcoder.json` | `theme: "dreamcoder"` in opencode config |
| **Codex CLI** | `Codex-CLI/Dreamcoder-{Mode}.tmTheme` | `theme = "Dreamcoder"` in codex config |
| **PI CLI** | `Pi/.pi/agent/themes/dreamcoder-{mode}.json` | `theme: "dreamcoder"` in pi settings |
| **Neovim** | `nvim-dreamcoder-{mode}.lua` | `require('dreamcoder')` in neovim config |
| **Zsh-syntax-highlighting** | `zsh-syntax-highlighting-dreamcoder-{mode}.zsh` | `source` after zsh-syntax-highlighting plugin |
| **LS_COLORS / eza** | `ls-colors-dreamcoder-{mode}.sh` | `source` in .zshrc or .bashrc |
| **Bat** | `bat-dreamcoder-{mode}.sh` | Sets `BAT_THEME` env var; pairs with Codex CLI tmTheme |
| **Delta (git diff)** | `delta-dreamcoder-{mode}.gitconfig` | `[include]` in `~/.config/git/config` |
| **Fzf** | `fzf-dreamcoder-{mode}.sh` | `source` in .zshrc or .bashrc |
| **Btop** | `btop-dreamcoder-{mode}.theme` | Place in `~/.config/btop/themes/` |
| **Dunst** | `dunst-dreamcoder-{mode}.conf` | `[include]` in dunstrc |
| **Firefox** | `firefox-dreamcoder-{mode}.css` | userChrome.css for Firefox customization |
| **Obsidian** | `obsidian-dreamcoder-{mode}.css` | CSS snippet in Obsidian vault |
| **Cava** | `cava-dreamcoder-{mode}.config` | `include` in `~/.config/cava/config` |

Important files:

```txt
themes/dreamcoder/tokens.json            # canonical design tokens: colors + guardrails
themes/dreamcoder/tokens.schema.json     # schema for the token contract
scripts/dreamcoder                       # unified CLI entrypoint
scripts/sync-dreamcoder-theme.py         # generator for core targets (terminals/opencode)
scripts/dreamcoder_theme/renderers.py              # shared rendering helpers
scripts/dreamcoder_theme/renderers_cli.py            # CLI targets (fzf, bat, delta, ls-colors, zsh-syntax)
scripts/dreamcoder_theme/renderers_desktop.py        # desktop-UI renderers (dunst, gtk)
scripts/dreamcoder_theme/renderers_hypr_waybar_rofi.py # Hyprland, Waybar, Rofi renderers
scripts/dreamcoder_theme/renderers_terminal.py       # terminal targets (kitty, ghostty, warp)
scripts/dreamcoder_theme/renderers_extra.py          # extra targets (neovim, fzf, bat, delta, etc.)
scripts/dreamcoder_theme/renderers_opencode.py       # opencode/Codex CLI theme renderers
scripts/dreamcoder_theme/renderers_codex.py          # Codex CLI tmTheme renderer
scripts/dreamcoder_theme/renderers_starship.py       # Starship prompt renderer
scripts/dreamcoder_theme/settings.py                 # schema-based token settings
scripts/dreamcoder_theme/palette_tokens.py           # token palette definitions
scripts/dreamcoder_theme/writers.py                  # file writer utilities
scripts/dreamcoder_theme/sync.py                     # stale-file cleanup & install orchestration
scripts/apply-theme-mode.sh                          # shared mode applier for all targets
scripts/install-dreamcoder-hooks.sh                  # one-time hook installer (symlinks, includes) — manual only, not called by install flow
scripts/theme-auto.sh                    # time-based light/dusk/dark selector
scripts/wallpaper-hook.sh                # robust wallpaper + Dreamcoder refresh hook
scripts/verify-theme-health.py           # contrast and eye-comfort guardrails
scripts/generate-theme-preview.py        # Markdown palette/contrast preview
Systemd/.config/systemd/user/*           # day/night user timer
```

## Design-token architecture

Dreamcoder has one canonical palette contract: `themes/dreamcoder/tokens.json`. The generator reads these tokens first, then emits terminal, Codex/opencode, Waybar, Rofi, Hyprland, and prompt outputs. This keeps the system coherent after ML4W/Gentleman updates and prevents each app from drifting into a different palette.

The token file includes hard guardrails: canonical opencode theme `dreamcoder`, no harsh pure black/white primary backgrounds, WCAG AA minimum token contrast, AAA target for main text, and APCA Lc checks for body and UI tokens.

See the auditable palette gallery: [docs/dreamcoder-theme-preview.md](docs/dreamcoder-theme-preview.md).

For the design-system contract, component model, accessibility policy, governance rules, and release checklist, see [docs/DREAMCODER_DESIGN_SYSTEM.md](docs/DREAMCODER_DESIGN_SYSTEM.md).

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
- APCA Lc ≥ 75 advisory for body tokens, ≥ 30 for UI affordances (APCA is public beta, WCAG remains authoritative);
- AA-or-better semantic token contrast for code, markdown, and diffs;
- 3:1+ contrast for meaningful focus rings and UI boundaries;
- typography and spacing tuned for fewer micro-adjustments.

⚠️ **APCA advisory**: APCA remains in public beta (Myndex/apca-w3 spec) and is not yet part of WCAG 3. All token pairs pass WCAG 2.1 AA/AAA minimums. See `docs/dreamcoder-theme-preview.md` for current APCA/WCAG audit.

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
themes/      Canonical theme tokens + generated snippets for all 22 targets
themes/dreamcoder/  tokens.json, tokens.schema.json, nvim, fzf, delta, dunst, etc.
scripts/     install, repair, doctor, theme sync, wallpaper, verification, preview
Systemd/     user timer/service for automatic day/night mode
```

## Verification

```bash
./scripts/dreamcoder verify
./scripts/verify-theme-health.py     # includes RGBA validation and target checks
python -m pytest -q                  # run the full test suite (81 tests)
```

A healthy setup should report linked configs, valid Starship, active timer, and passing visual-health guardrails. Use `./scripts/dreamcoder preview` after palette edits to refresh the auditable preview gallery.

## CI/CD

GitHub Actions validates theme health on push/PR to `tokens.json` and renderer changes. Pre-commit hooks can be installed locally:

```bash
pip install pre-commit
pre-commit install
```

---

## 🌐 Dreamcoder Ecosystem

| Project | Description |
|---------|-------------|
| [Dreamcoder08](https://github.com/Dreamcoder08) | Software Architect · GDE · MVP — Profile |
| [DreamFolio](https://github.com/Dreamcoder08/DreamFolio) | High-performance portfolio — Astro, React, Tailwind |
| [CleanSweep](https://github.com/Dreamcoder08/CleanSweep) | AI-assisted dotfile manager in Rust |
| [ARKELYTHEX](https://github.com/arkelythex) | Civic, Agri & Legal Tech for Peru |
