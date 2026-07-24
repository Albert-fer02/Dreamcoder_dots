# Tasks: Hexagonal Architecture Refactor — Phase 1

## T1: Create Shell Library `lib/`

- **Estimate**: 45 min
- **Dependencies**: None
- **Files**: `lib/core.sh`, `lib/theme.sh`, `lib/hyprland.sh` (NEW)
- **Description**:
  - `core.sh`: `ensure_dots_dir()`, `log_info/warn/error()`, `require_command()`, `is_gui_session()`
  - `theme.sh`: `detect_theme_mode()`, `load_theme_tokens()`
  - `hyprland.sh`: `reload_hyprland()`, `restart_waybar()`, `signal_kitty()`
- **Acceptance**: `bash -n lib/*.sh` passes, all functions documented

## T2: Refactor Scripts to Use `lib/`

- **Estimate**: 60 min
- **Dependencies**: T1
- **Files**: `scripts/apply-theme-mode.sh`, `scripts/doctor.sh`, `scripts/generate-custom-lua.sh`, `scripts/dreamcoder.sh`, `scripts/apply-system-mode.sh` (MODIFY)
- **Description**:
  - Replace all inline `DREAMCODER_DOTS_DIR` resolution with `ensure_dots_dir`
  - Replace `is_gui_session` checks with `lib/core.sh` function
  - Replace raw `echo` with `log_info/warn/error`
  - Replace `command -v x || echo "missing"` with `require_command`
- **Acceptance**: Zero inline `DREAMCODER_DOTS_DIR=` assignments outside lib, `bash -n` passes

## T3: Add Shell Tests (bats)

- **Estimate**: 60 min
- **Dependencies**: T2
- **Files**: `tests/shell/test_apply_theme.bats`, `tests/shell/test_doctor.bats`, `tests/shell/test_lib_core.bats` (NEW)
- **Description**:
  - Library tests: `ensure_dots_dir`, `is_gui_session`, `require_command`
  - Apply theme: `--help`, mode=light syntax, mode=dark syntax
  - Doctor: `--help`, runs without crash in check mode
- **Acceptance**: `bats tests/shell/` passes all tests

## T4: Extract Domain Layer — Palette

- **Estimate**: 30 min
- **Dependencies**: None
- **Files**: `src/dreamcoder_theme/domain/__init__.py`, `src/dreamcoder_theme/domain/palette.py` (NEW), `src/dreamcoder_theme/palette.py` (MODIFY — re-export)
- **Description**:
  - Move pure color functions to `domain/palette.py`: `contrast_ratio`, `relative_luminance`, `blend`, `ensure_contrast`, `hex_to_rgb`, `rgb_to_hex`
  - Keep matugen subprocess calls in adapter or original location
  - Original `palette.py` re-exports from domain for backward compat
- **Acceptance**: All existing pytests pass, domain/palette.py imports zero I/O modules

## T5: Extract Domain Layer — Mode Detector

- **Estimate**: 20 min
- **Dependencies**: None
- **Files**: `src/dreamcoder_theme/domain/mode_detector.py` (NEW), `src/dreamcoder_theme/core.py` (MODIFY — re-export)
- **Description**:
  - Move `detect_mode_from_file`, mode-related constants to `domain/mode_detector.py`
  - Pure function: `ModeDetector.from_file_content(text: str) → str`
  - Original `core.py` re-exports
- **Acceptance**: All existing pytests pass, mode_detector.py imports zero I/O modules

## T6: Create Port Interfaces

- **Estimate**: 20 min
- **Dependencies**: None
- **Files**: `src/dreamcoder_theme/ports/__init__.py`, `ports/renderer.py`, `ports/writer.py` (NEW)
- **Description**:
  - `Renderer` ABC with `render(tokens) → RenderResult` + `target_name` property
  - `Writer` ABC with `write(path, content)`, `symlink(source, target)`
- **Acceptance**: ABCs instantiable only by subclasses implementing all abstract methods

## T7: Create Adapter — FileWriter

- **Estimate**: 15 min
- **Dependencies**: T6
- **Files**: `src/dreamcoder_theme/adapters/__init__.py`, `adapters/file_writer.py` (NEW)
- **Description**:
  - Implements `Writer` ABC
  - Atomic writes (temp file + rename)
  - Directory auto-creation
- **Acceptance**: `isinstance(FileWriter(), Writer)` is True, atomic write test passes

## T8: Integration — ThemeApplier (Phase 1 partial)

- **Estimate**: 30 min
- **Dependencies**: T4, T5, T6, T7
- **Files**: `src/dreamcoder_theme/application/__init__.py`, `application/theme_applier.py` (NEW)
- **Description**:
  - Minimum viable ThemeApplier: loads tokens, renders all targets, writes via FileWriter
  - Plugs into `scripts/apply-theme-mode.sh` (old path still works)
- **Acceptance**: Can apply light/dark theme via Python, output identical to old shell path

## T9: Add Domain Unit Tests

- **Estimate**: 30 min
- **Dependencies**: T4, T5
- **Files**: `tests/unit/test_palette.py`, `tests/unit/test_mode_detector.py` (NEW)
- **Description**:
  - Palette: test contrast_ratio with known WCAG pairs, blend with known ratios
  - ModeDetector: test with light tokens, dark tokens, unknown tokens
- **Acceptance**: `pytest tests/unit/ -v` passes, coverage ≥ 90% for domain modules

## T10: Regression Test Suite

- **Estimate**: 20 min
- **Dependencies**: T1–T9
- **Files**: None (verification only)
- **Description**:
  - Run full pytest suite: must pass (minus pre-existing Anthracite Steel failures)
  - Run bats shell tests: must pass
  - Run `bash -n` on all scripts: must pass
  - Run `scripts/validate-ml4w-profiles.py`: must pass
- **Acceptance**: All checks pass, zero regressions

## Execution Order

```
T4 ──→ T9 ──┐
T5 ─────────┤
T6 ──→ T7 ──┼──→ T8 ──→ T10
T1 ──→ T2 ──┤
            T3 ──┘
```

## Review Workload Forecast

- **Total changed lines**: ~800 (new files + modified scripts)
- **Chained PRs recommended**: Yes — split into PR1 (T1-T3 shell) + PR2 (T4-T9 Python)
- **400-line budget risk**: High — needs two separate commits
- **Decision needed before apply**: Yes — commit after T1-T3 or wait for full Phase 1?
