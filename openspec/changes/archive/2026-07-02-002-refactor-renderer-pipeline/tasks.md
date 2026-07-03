# Tasks: Refactor Renderer Pipeline

## Review Workload Forecast

| Field                   | Value                                                                                                  |
| ----------------------- | ------------------------------------------------------------------------------------------------------ |
| Estimated changed lines | 440–480                                                                                                |
| 400-line budget risk    | High                                                                                                   |
| Chained PRs recommended | Yes                                                                                                    |
| Suggested split         | PR 1: palette + 12 renderers (~38 lines) → PR 2: writers + sync (~372 lines) → PR 3: tests (~50 lines) |
| Delivery strategy       | auto-chain                                                                                             |
| Chain strategy          | stacked-to-main                                                                                        |

Decision needed before apply: No
Chained PRs recommended: Yes
Chain strategy: stacked-to-main
400-line budget risk: High

### Suggested Work Units

| Unit | Goal                                                                                | Likely PR | Notes                                                                                    |
| ---- | ----------------------------------------------------------------------------------- | --------- | ---------------------------------------------------------------------------------------- |
| 1    | Centralize mode detection: palette.ansi() fix + all 12 renderers use detect_mode(c) | PR 1      | Base: main. Mechanical replacements only; no behavioral change.                          |
| 2    | Writers helper + declarative sync registry replacing ~270 lines                     | PR 2      | Base: main. Independent of PR 1; write_variant_files_and_active + VARIANT_REGISTRY loop. |
| 3    | Tests for registry structure, helper delegation, and write-order                    | PR 3      | Base: main. Mock-based unit tests + existing suite regression.                           |

## Phase 1: Foundation — Palette & Writers

- [x] 1.1 Fix `ansi()` in `src/dreamcoder_theme/palette.py` line 221: replace inline `"dark" if palette["details"] == "darker"` with `detect_mode(palette)`
- [x] 1.2 Add `write_variant_files_and_active(base, names, builder, variants, active, active_path)` to `src/dreamcoder_theme/writers.py` — compose `write_variant_files` then `write_if_changed`; return combined `list[bool]`

## Phase 2: Core — Renderers & Sync Registry

- [x] 2.1 Replace inline mode detection in 10 simple renderers: `renderers_opencode.py`, `renderers_ghostty_warp.py`, `renderers_starship.py`, `renderers_extra_firefox.py`, `renderers_extra_btop.py`, `renderers_tmux.py`, `renderers_extra_obsidian.py`, `renderers_kitty.py`, `renderers_pi.py`, `renderers_extra_notify.py` — use `detect_mode(c)`; remove `is_dark` locals
- [x] 2.2 Remove `_mode()` from `renderers_extra_shell.py`; replace its 4 call sites with `detect_mode(c)`
- [x] 2.3 Remove `_detect_mode()` from `renderers_extra_bat_delta.py`; replace its 2 call sites with `detect_mode(c)`
- [x] 2.4 Define `VARIANT_REGISTRY` (20 entries) and rewrite `sync_repo_snippets()` in `src/dreamcoder_theme/sync.py`: registry loop uses `write_variant_files_and_active` for uniform entries; keep hyprland/waybar/rofi/nvim/kitty-ui/opencode-transparent as direct calls below loop
- [x] 2.5 Verify zero remaining `c["details"] == "darker"`, `def _detect_mode`, or `def _mode` in `src/dreamcoder_theme/`

## Phase 3: Testing

- [x] 3.1 Add registry structure tests to `tests/test_dreamcoder_sync.py`: assert ≥18 entries, each a 4-tuple, content fns callable, no hyprland/waybar/rofi/nvim entries present
- [x] 3.2 Add write-order determinism test: mock `write_variant_files`, assert call sequence matches registry entry order
- [x] 3.3 Add `write_variant_files_and_active` delegation tests to `tests/test_dreamcoder_writers.py`: mock both inner functions, verify call order and combined return
- [x] 3.4 Run full `pytest tests/` — all existing tests pass unchanged
