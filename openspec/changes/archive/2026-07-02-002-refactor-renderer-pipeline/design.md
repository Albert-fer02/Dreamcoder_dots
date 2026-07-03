# Design: Refactor Renderer Pipeline

## Technical Approach

Three independent refactors sharing the same change envelope:

1. **Centralize mode detection** — replace 15 inline `c["details"] == "darker"` / local `_detect_mode()` / `_mode()` calls with `palette.detect_mode(c)`. Fix `ansi()` to delegate.
2. **Declarative sync registry** — define `VARIANT_REGISTRY` as a list of `(dir, filename_map, content_fn, active_path?)` tuples. Loop replaces ~270 lines of repetitive `write_variant_files` + `write_if_changed` blocks in `sync_repo_snippets()`.
3. **Composite writer helper** — add `write_variant_files_and_active()` composing variant writes followed by active-file write.

All three are mechanical; zero behavioral change.

## Architecture Decisions

| Option                                                                                                     | Tradeoff                                                                              | Decision                                                                                                                   |
| ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `detect_mode(c)` signature: `c["details"]` vs `c.get("details")`                                           | `.get()` returns `"light"` on missing key (defensive); `c["details"]` raises KeyError | `.get()` — already the canonical impl at `palette.py:233`. All renderers pass well-formed palette dicts, so both are safe. |
| Registry tuple shape: `(dir, names, fn, active_path?)` vs `(dir, names, fn, active_path, active_builder?)` | Separate active_builder for kitty (kitty_ui_content ≠ kitty_content) adds complexity  | 4-tuple with optional active_path. Non-uniform cases (kitty-ui, opencode transparent) stay as direct calls below the loop. |
| `write_variant_files_and_active` vs inline in registry loop                                                | Helper is testable independently; inline keeps sync surface smaller                   | Helper in writers.py — testable in isolation, reusable if future sync patterns need it.                                    |
| Nvim entries in registry vs direct                                                                         | Nvim variant files use same `write_variant_files` pattern as other renderers          | Direct calls per spec requirement — keeps WM/app entries grouped for clarity.                                              |
| Registry count: hardcoded 20 vs dynamic scan                                                               | Dynamic scan breaks on refactor; hardcoded is fragile but testable                    | Assert ≥18 entries in test (proposal's ~18 variant blocks); exact count drifts safely with additions.                      |

## Data Flow

```
sync_repo_snippets(variants, active)
    │
    ├─ VARIANT_REGISTRY loop (20 entries)
    │   ├─ write_variant_files(base, names, fn, variants)     → variant files
    │   └─ write_if_changed(active_path, fn(active))           → active file (optional)
    │
    ├─ Direct calls (non-uniform)
    │   ├─ kitty-ui (different content fn)
    │   ├─ codex_app_active + opencode_dotfile (different paths/signatures)
    │   ├─ hyprland dark/light + active
    │   ├─ hypr_colors_lua + conf variants
    │   ├─ waybar dark/light + active
    │   ├─ rofi dark/light + active
    │   ├─ nvim variants + active
    │   └─ readme
    │
    └─ list[bool]
```

## File Changes

| File                                                | Action | Description                                                                                          |
| --------------------------------------------------- | ------ | ---------------------------------------------------------------------------------------------------- |
| `src/dreamcoder_theme/palette.py`                   | Modify | `ansi()` line 221: replace `"dark" if palette["details"] == "darker"` with `detect_mode(palette)`    |
| `src/dreamcoder_theme/sync.py`                      | Modify | Add `VARIANT_REGISTRY` (20 entries). Rewrite `sync_repo_snippets()` as registry loop + direct calls. |
| `src/dreamcoder_theme/writers.py`                   | Modify | Add `write_variant_files_and_active(base, names, builder, variants, active, active_path)`            |
| `src/dreamcoder_theme/renderers_opencode.py`        | Modify | Replace 2x inline mode detection with `detect_mode(c)`                                               |
| `src/dreamcoder_theme/renderers_ghostty_warp.py`    | Modify | Replace `is_dark = c["details"] == "darker"` with `detect_mode(c) == "dark"`                         |
| `src/dreamcoder_theme/renderers_starship.py`        | Modify | Replace inline with `detect_mode(c)`                                                                 |
| `src/dreamcoder_theme/renderers_extra_shell.py`     | Modify | Remove `_mode()` function; replace 4 call sites with `detect_mode(c)`                                |
| `src/dreamcoder_theme/renderers_extra_firefox.py`   | Modify | Replace inline with `detect_mode(c)`                                                                 |
| `src/dreamcoder_theme/renderers_extra_btop.py`      | Modify | Replace inline with `detect_mode(c)`                                                                 |
| `src/dreamcoder_theme/renderers_tmux.py`            | Modify | Replace `is_dark = c["details"] == "darker"` with `detect_mode(c) == "dark"`                         |
| `src/dreamcoder_theme/renderers_extra_obsidian.py`  | Modify | Replace inline with `detect_mode(c)`                                                                 |
| `src/dreamcoder_theme/renderers_kitty.py`           | Modify | Replace `is_dark = c["details"] == "darker"` with `detect_mode(c) == "dark"`                         |
| `src/dreamcoder_theme/renderers_extra_bat_delta.py` | Modify | Remove `_detect_mode()` function; replace 2 call sites with `detect_mode(c)`                         |
| `src/dreamcoder_theme/renderers_pi.py`              | Modify | Replace inline with `detect_mode(c)`                                                                 |
| `src/dreamcoder_theme/renderers_extra_notify.py`    | Modify | Replace 2x inline mode detection with `detect_mode(c)`                                               |
| `tests/test_dreamcoder_sync.py`                     | Modify | Add registry structure + write-order tests                                                           |
| `tests/test_dreamcoder_writers.py`                  | Modify | Add `write_variant_files_and_active` delegation tests                                                |

## Interfaces / Contracts

```python
# palette.py — already exists, unchanged signature
def detect_mode(c: dict[str, str]) -> str:
    """Return "dark" or "light" based on the palette's details key."""
    return "dark" if c.get("details") == "darker" else "light"

# writers.py — new
def write_variant_files_and_active(
    base: Path,
    names: dict[str, str],
    builder: Callable[..., str],
    variants: dict[str, dict[str, str]],
    active: dict[str, str],
    active_path: Path,
) -> list[bool]:
    changes = write_variant_files(base, names, builder, variants)
    changes.append(write_if_changed(active_path, builder(active)))
    return changes

# sync.py — new registry structure
VARIANT_REGISTRY: list[tuple[Path, dict[str, str], Callable[..., str], Path | None]]
```

## Testing Strategy

| Layer       | What to Test                                                                             | Approach                                                                |
| ----------- | ---------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Unit        | `VARIANT_REGISTRY` has ≥18 entries, each 4-tuple, content fns callable                   | Structural assertions in `test_dreamcoder_sync.py`                      |
| Unit        | `write_variant_files_and_active` delegates to `write_variant_files` + `write_if_changed` | Mock both; verify call order in `test_dreamcoder_writers.py`            |
| Unit        | Registry loop preserves insertion order                                                  | Mock `write_variant_files`; assert call sequence matches registry order |
| Integration | No behavioral change — existing tests pass unchanged                                     | Run full `pytest tests/` before/after                                   |

## Migration / Rollout

No migration required. Pure internal refactor. Rollback: `git checkout -- src/dreamcoder_theme/ tests/`.

## Open Questions

None — all decisions resolved from codebase reading and spec alignment.
