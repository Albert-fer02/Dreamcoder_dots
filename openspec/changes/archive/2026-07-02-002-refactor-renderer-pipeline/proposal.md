# Proposal: Refactor Renderer Pipeline

## Intent

Eliminate duplicated mode detection across 15+ sites and ~270 lines of boilerplate in `sync_repo_snippets()`. Every new renderer copies the same `"dark" if c["details"] == "darker"` pattern; `sync_repo_snippets` is a wall of near-identical blocks.

## Scope

### In Scope

- Consolidate 15+ inline `detect_mode` reimplementations to use `palette.detect_mode()` (already exists, unused)
- Convert `sync_repo_snippets()` to a declarative variant registry (data loop + active writes)
- Add `write_variant_files_and_active()` helper to writers.py
- Add tests for the sync registry and new helper
- Fix `ansi()` in palette.py to use `detect_mode()` internally

### Out of Scope

- Guard factory / `make_guard()` — deferred
- Merge `renderers_codex.py` — deferred
- Restructure `renderers.py` import hub — deferred
- Any behavioral change to renderer output

## Capabilities

> Pure refactor — no spec-level changes.

### New Capabilities

None

### Modified Capabilities

None

## Approach

1. **palette.py**: Replace inline mode detection inside `ansi()` with `detect_mode()`.
2. **Renderers**: Replace all 15 inline expressions with `detect_mode(c)`. Remove local `_detect_mode()` / `_mode()` functions.
3. **writers.py**: Add `write_variant_files_and_active(base, names, builder, variants, active)` — calls write_variant_files then write_if_changed for the active file.
4. **sync.py**: Define a declarative `VARIANT_REGISTRY` of tuples `(dir, filename_map, content_fn, active_path?)`. Loop over it in `sync_repo_snippets()`. Keep hyprland/waybar/rofi and nvim entries as direct calls.
5. **tests/**: Add registry structure tests and helper delegation tests.

## Affected Areas

| Area                         | Impact   | Description                              |
| ---------------------------- | -------- | ---------------------------------------- |
| `palette.py`                 | Modified | `ansi()` uses `detect_mode()`            |
| `sync.py`                    | Modified | Declarative registry replaces ~270 lines |
| `writers.py`                 | Modified | New `write_variant_files_and_active()`   |
| 12 renderer modules          | Modified | Use `palette.detect_mode()`              |
| `test_dreamcoder_sync.py`    | Modified | Registry structure + write-order tests   |
| `test_dreamcoder_writers.py` | Modified | Helper delegation tests                  |

## Risks

| Risk                           | Likelihood | Mitigation                                     |
| ------------------------------ | ---------- | ---------------------------------------------- |
| Missed mode-detection site     | Low        | Grep `c\["details"\]` across all renderers     |
| Registry write-order diff      | Low        | Append loop preserves insertion order          |
| Active-path mismatch           | Low        | One explicit test per active variant           |
| Tests reference removed locals | Low        | Check no test imports `_detect_mode` / `_mode` |

## Rollback Plan

`git checkout -- src/dreamcoder_theme/ tests/` reverts all changes.

## Dependencies

- Python 3.12+
- `pytest`

## Success Criteria

- [ ] `detect_mode(c)` used in all 15 locations + palette.ansi()
- [ ] No remaining local `_detect_mode` / `_mode` functions
- [ ] `sync_repo_snippets()` produces identical file set and content
- [ ] Registry test asserts 18+ entries (matching current ~18 variant blocks)
- [ ] All existing tests pass unchanged
