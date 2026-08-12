# Changelog

## Unreleased

### Changed

- **Prefix restructure**: 22 directorios renombrados con prefix `Dreamcoder*` (estilo Gentleman.Dots).
  Config tools (Alacritty → DreamcoderAlacritty, Kitty → DreamcoderKitty, etc.), AI configs
  (Pi → DreamcoderPi, Codex-*→ DreamcoderCodex*, Antigravity → DreamcoderAntigravity),
  y assets (themes → DreamcoderThemes, Wallpapers → DreamcoderWallpapers, profiles → DreamcoderProfiles).
  Infra (src, tests, installer, scripts, docs) mantiene nombres estándar.
- Actualizadas todas las referencias internas: installer Go, theme engine Python, scripts,
  tests, docs, CI workflows, .gitignore, CODEOWNERS.
- Symlink `unknown` convertido de absoluto a relativo.

### Fixed

- **Hyprland rgba converter**: `_rgba_to_argb` usaba `zfill(2)`, que solo rellena y nunca trunca, generando `rgba()` inválidos de 10 chars (p.ej. `rgba(13811588ed)`). Ahora clamp con `int():02x` + guard de conversión + tests de regresión.
- **Migración Anthracite Steel**: paleta dark propagada a los 24 consumers trackeados (opencode, firefox, waybar, dunst, rofi, btop, obsidian, hyprland, zsh-syntax, etc.), regenerada con el engine y verificada por idempotencia.
- **Writers del engine**: `write_if_changed` normaliza a exactamente un newline final (POSIX), eliminando el churn del hook `end-of-file-fixer` en cada commit.
- **Health gate opencode**: el check de `.opencode/themes/dreamcoder.json` ahora es mode-aware (acepta dark/light/dusk según el contrato declarado) en vez de hardcodear light — el checkout limpio volvía a fallar tras la migración.
- **Iconos de `ls` en fish**: los abbrs shadowean a los aliases; los listings ahora son abbrs con `--icons=always` y guard de eza, y `16-dreamcoder-icons.fish` queda solo como fallback sin eza.
- **Symlink `unknown` (causa raíz)**: el repair planner copiaba el string del modo detectado (`detail`) como target del symlink; ahora target absoluto explícito (kitty colors) + guard que rechaza targets no absolutos. El bug no debería volver a aparecer.
- **Suite de tests hermética**: `test_pi_theme_generation` spawnaba el sync sin aislar los `DREAMCODER_*_THEME`, escribiendo los activos del repo (una corrida light dejaba los archivos en light). Aislado con env vars → `pytest` ya no ensucia el working tree.
- **Generación repo-only**: `sync_repo_snippets` ahora escribe también los activos del repo-root (dos sets de consumidores: apps que copian vs desktop con symlinks), eliminando el drift entre ambos.
- **CI pipeline desbloqueado**: los 3 workflows (CI, Integration Test, Repository Sync Enforcement) volvieron a pasar. El sync module ganó el guard `__main__` (el comando documentado `python -m dreamcoder_theme.sync` no hacía nada); shellcheck en CI usa `--severity=warning` (SC1091 info); el integration test completa el install mock (symlinks de themes dir + variantes kitty, fish/starship instalados) y el test de contrato bat se alinea al formato canónico.
- **Toolchain al día (ago 2026)**: pre-commit-hooks v6.0.0, ruff-pre-commit v0.16.2 (PLR0917 al ignore, consistente con PLR0913), mirrors-mypy v2.3.0, shellcheck-py v0.11.0.1. Actions de GitHub pineados por commit SHA en majors actuales (checkout v7.0.1, setup-node/python/go v7, upload-artifact v7.0.1); commitlint a Node 24; matrix de Python +3.14. uv y ruff actualizados localmente (uv 0.12.3, ruff 0.16.2).

### Changed

- **Default dark**: `theme_mode()` del engine y `DREAMCODER_THEME_MODE` de fish ahora default a `dark` (Anthracite Steel) — un env limpio (CI, shell nueva) ya no regenera/sourcea la paleta light legacy.
- **Untrack `colors-matugen.conf`**: la paleta de matugen (derivada del wallpaper) dejó de trackearse; el `.gitignore` ahora funciona como se pretendía.
- **`cat`/`gl` en fish**: `cat` alineado a `bat --paging=never`; alias muerto de `gl` eliminado (redundante con `glg` y shadoweado por el abbr `--oneline -20`).
- **Theme preview regenerado** para la migración Anthracite Steel (desbloquea el gate de CI de uncommitted changes).

### Added

- PEP 621 packaging: `pyproject.toml` with setuptools build backend, `__version__` in package.
- `dreamcoder-theme` CLI entry point (`dreamcoder-theme sync|doctor|paths`).
- `Makefile` with targets: install, test, coverage, build, clean, lint.
- `CONTRIBUTING.md` with dev setup guide, test runner, and PR workflow.
- PyPI trusted publisher CI workflow — auto-publishes on `v*` tag pushes.
- CI test matrix: Python 3.11 + 3.12, coverage reporting, lint.

### Changed

- README restructured: PyPI package section added above dotfiles installation guide.

### Added

- Automated terminal readability guardrails for ANSI colors, cursor contrast, and selection contrast.
- Design system governance documentation for Dreamcoder's product definition, token contract, component model, accessibility policy, and release readiness checklist.
- Global design-system regression tests covering APCA dark diagnostic contrast, governance docs, README discoverability, and changelog discipline.
- RGBA token validation in `verify-theme-health.py` with structured format checking.
- Multi-target validation in `verify-theme-health.py` (Kitty, Ghostty, Waybar, Hyprland, Rofi, Btop, Dunst, Fzf).
- GitHub Actions workflow (`.github/workflows/theme-validation.yml`) for CI theme checks.
- Pre-commit hooks (`.pre-commit-config.yaml`) for local validation.
- Flexible systemd service path resolution via `dreamcoder-run.sh` helper.

### Changed

- Fixed 5 malformed `inactive_border` RGBA values in `tokens.json` and `palette_tokens.py`.
- Corrected APCA implementation to spec (polarity-aware exponents, black soft-clamp, hysteresis offset).
- Aligned APCA thresholds to 2025-2026 research (Lc 75/30/45, no dark-mode special case).
- Added `rgba_color` definition to `tokens.schema.json`.
- Updated `visual health policy` section in README with APCA advisory status.
- `check_apca_or_warn()` now logs advisory warnings instead of failing (WCAG stays authoritative).
- Visual regression test now skips missing plugin dependencies gracefully.
- Hyprland renderer converts RGBA to ARGB compact format automatically.
- Fixed opencode `textSelected` in light mode - selection text now inverts to background color instead of using main text color.

### Known Tradeoffs

- Dark `diagnostic` color (#5f95ca) scores APCA Lc 42.7 (below 75 advisory) but WCAG 6.00:1 (AA pass).
- Dark `border_ui` scores APCA Lc 25.1 (below 30 advisory) but WCAG 3.60:1 (passes UI requirement).
