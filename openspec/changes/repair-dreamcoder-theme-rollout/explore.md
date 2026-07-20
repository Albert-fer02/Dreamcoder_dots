# Exploration: Repair Dreamcoder Theme Rollout

## Scope

Investigate the reported `window-title: unknown field` and `tab-title: unknown field` errors, and map how Dreamcoder Light/Dark are generated and applied through Gentleman Dots installation and runtime entrypoints. No implementation was performed.

## Repository evidence and CodeGraph note

The repository has no `.codegraph/` directory, and CodeGraph was not available through the executor tool surface. Structural exploration therefore used targeted repository searches and direct reads after that failed check.

## Exact error source diagnosis

The exact strings `window-title` and `tab-title` do **not** occur in tracked repository configuration or source. The repository contains no Herdr configuration files (`config.dark.toml`, `config.light.toml`) and no Herdr schema/version declaration. Therefore the screenshot error is not emitted by a checked-in Dreamcoder renderer, and the consuming application's exact supported configuration version cannot be proven from repository evidence alone.

The only repository integration for the named application is:

- `DreamcoderShell/.config/fish/config.fish`: starts `herdr` for interactive Fish sessions when not already inside Herdr/Tmux/Zellij.
- `scripts/herdr-theme-switch.sh`: switches `~/.config/herdr/config.toml` between `config.dark.toml` and `config.light.toml`, then runs `herdr server reload-config` when the executable exists.
- `scripts/apply-theme-mode.sh`: invokes that switcher after the generated theme sync and reports the selected mode.

The most likely immediate cause is that one or both external Herdr TOML variants contain keys unsupported by the installed Herdr release. That remains a hypothesis: the offending files and installed Herdr version must be inspected on the target machine. `window-title` and `tab-title` may also belong to a different application accidentally associated with the user’s `herdr` reference; repository evidence cannot resolve that further.

## Theme generation and target coverage

Canonical tokens are in `DreamcoderThemes/dreamcoder/tokens.json`; Python-generated token constants are in `src/dreamcoder_theme/palette_tokens.py`. The engine loads dark/light variants, optionally adapts them to wallpaper colors, and writes active targets plus repository variants.

`src/dreamcoder_theme/sync.py` currently covers:

- Kitty colors and UI include
- Ghostty theme and active config
- Warp theme and settings
- OpenCode theme/TUI settings
- Codex and Bat themes
- Pi CLI theme/settings
- Starship and Tmux
- Zellij active theme selection
- Neovim dispatcher and dark/light files
- zsh syntax highlighting, LS_COLORS, Bat, Delta, fzf, btop, Dunst, Firefox, Obsidian, and Cava
- Hyprland, Waybar, and Rofi generated outputs and mode variants

The declarative `VARIANT_REGISTRY` writes dark/light siblings for terminal, shell, editor, CLI, and theme-snippet targets. Non-uniform outputs are written explicitly for Kitty UI, OpenCode, Hyprland, Waybar, Rofi, and Neovim. The active runtime paths are defined in `src/dreamcoder_theme/settings.py`; the `DREAMCODER_*` environment variables allow target overrides.

`apply-theme-mode.sh` is the runtime fan-out: validates light/dark, exports mode-related CLI environment, applies system mode, runs optional Matugen, flips mode symlinks for Waybar/Rofi/Hyprland/Kitty, switches Pi, invokes `sync-dreamcoder-theme.py`, reloads Kitty/Waybar, propagates Tmux state and colors, invokes Herdr switching, then repairs Warp/Btop/Zellij active links/config. The engine itself only accepts `dark` and `light`; the documented dusk schedule is handled outside the engine by the timer/application schedule, not as a sync mode.

## Installation/apply entrypoints

- `scripts/install.sh` delegates to `scripts/dreamcoder-maintenance.sh install`.
- `scripts/dreamcoder.sh` is the user-facing command and dispatches install, mode switching, status, doctor, repair, and control-center flows.
- `scripts/dreamcoder-maintenance.sh install` backs up managed targets, Stows `Shell Kitty Ghostty Fastfetch Warp Bat Systemd`, applies ML4W/CLI/Fastfetch hooks, enables the systemd theme timer, and runs `theme-auto.sh`.
- `scripts/dreamcoder-maintenance.sh repair` reapplies hooks, optionally re-Stows modules, enables the timer, runs `theme-auto.sh`, and verifies.
- `scripts/theme-auto.sh` selects light between configured light/dark hours and otherwise dark, then delegates to `apply-theme-mode.sh`.
- `scripts/sync-dreamcoder-theme.py` is the direct generator entrypoint and invokes `dreamcoder_theme.sync`.
- `scripts/install-dreamcoder-hooks.sh` installs additional application hooks and documents automatic light/dark switching.

The installation module list does not include a `Herdr` Stow module. Herdr is integrated only through the shell startup and mode-switch script, and its expected config files must already exist under `~/.config/herdr` or be supplied by an external/untracked installation step. This is a concrete rollout gap if Herdr is intended to be a first-class Gentleman Dots target.

## `herdr` ambiguity resolution

Repository evidence confirms `herdr` is an executable/application name, not a typo: it is launched from Fish, receives `server reload-config`, and has two expected TOML config variants. However, the repository does not identify its upstream project, version, schema, or checked-in configuration. The user’s reference is therefore resolved only to this external Herdr integration; the exact screenshot-producing consumer and supported key syntax remain an explicit ambiguity for proposal planning.

## Planning implications

1. Inspect the target machine’s `~/.config/herdr/config.toml`, `config.dark.toml`, and `config.light.toml`, plus `herdr --version`/help or upstream schema, before changing keys.
2. Decide whether Herdr should gain tracked Dreamcoder Light/Dark configs and become an installation module, or remain an external config managed by the switcher.
3. Preserve the token-driven engine as the source of truth; avoid hand-editing generated palette outputs.
4. Add regression coverage for the supported Herdr format and for install/apply mode propagation once the external schema is confirmed.
5. Verify all existing Gentleman Dots modules and hook entrypoints so Light and Dark are both installed, generated, selected, and reloaded consistently.

## Risks and unresolved items

- **Critical information gap:** the screenshot files and Herdr version are outside the repository, so exact unsupported-field replacement cannot be specified safely yet.
- Existing `scripts/apply-theme-mode.sh` tolerates Herdr reload failure (`|| true` inside the switcher), which can make a broken Herdr rollout appear successful.
- The installer’s Stow module list omits Herdr despite runtime integration.
- Repository docs still describe the broader installation flow in Spanish, while new OpenSpec artifacts follow the project’s English technical-artifact convention.
