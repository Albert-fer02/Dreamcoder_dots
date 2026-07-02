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
