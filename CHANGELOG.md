# Changelog

## Unreleased

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
