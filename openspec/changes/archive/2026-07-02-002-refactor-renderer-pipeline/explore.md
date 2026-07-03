## Exploration: Refactor Renderer Pipeline

### Current State

The dreamcoder-dots renderer pipeline consists of ~20 individual renderer modules under `src/dreamcoder_theme/`, organized as follows:

- **`renderers.py`** — flat import hub re-exporting all renderer functions
- **`renderers_opencode.py`** — produces OpenCode JSON theme via `opencode_tokens()` (shared token computation) + `opencode_content()` (full JSON schema)
- **`renderers_codex.py`** — thin wrapper that calls `opencode_tokens()` and formats as tmTheme XML
- **`renderers_pi.py`** — calls `opencode_tokens()` and formats as Pi agent JSON
- **`renderers_kitty.py`**, **`renderers_ghostty_warp.py`** — terminal renderers
- **`renderers_starship.py`**, **`renderers_tmux.py`** — prompt/tmux renderers
- **`renderers_extra_shell.py`** — zsh, LS_COLORS, fzf
- **`renderers_extra_bat_delta.py`** — bat theme config + git delta config
- **`renderers_extra_btop.py`** — btop theme
- **`renderers_extra_notify.py`** — dunst + cava
- **`renderers_extra_firefox.py`** — Firefox CSS
- **`renderers_extra_obsidian.py`** — Obsidian CSS
- **`renderers_extra_nvim.py`** — Neovim Lua dispatcher + colorscheme (delegates to separate lsp/plugins/syntax/ui modules)
- **`renderers_antigravity.py`** — Antigravity theme
- **`renderers_hypr_waybar_rofi.py`** — large module with Material 3 color mapping
- **`renderers_readme.py`** — README generator

**`sync.py`** orchestrates two pass types:

- `sync_active_targets()` — writes to user's live config paths
- `sync_repo_snippets()` — writes variant (dark/light) copies to repo snippet directories — **extremely repetitive** (~270 lines of near-identical `write_variant_files()` calls)

**`writers.py`** provides filesystem helpers:

- `write_if_changed()` — atomic write with change detection
- `write_variant_files()` — batch variant writer using `write_if_changed`
- Various app-config updaters (ghostty, warp, zellij, kitty, codex, pi)

### Duplicated / Redundant Patterns Identified

#### 1. Mode Detection Repetition (6+ locations)

Each renderer independently determines dark/light mode:

| File                           | Pattern                                           |
| ------------------------------ | ------------------------------------------------- |
| `renderers_opencode.py`        | `"dark" if c["details"] == "darker" else "light"` |
| `renderers_pi.py`              | `"dark" if c["details"] == "darker" else "light"` |
| `renderers_extra_bat_delta.py` | `_detect_mode(c)` — standalone function           |
| `renderers_extra_btop.py`      | `"dark" if c["details"] == "darker" else "light"` |
| `renderers_extra_shell.py`     | `_mode(c)` — standalone function                  |
| `renderers_starship.py`        | `"dark" if c["details"] == "darker" else "light"` |
| `palette.py`                   | has `detect_mode()` but **nobody imports it**     |

**Fix**: Export `detect_mode()` from `palette.py` and use it everywhere.

#### 2. guard() + low-level pattern duplication

Nearly every renderer that computes foreground/syntax colors repeats:

```python
mode = "dark" if c["details"] == "darker" else "light"
fg = guard(c["accent"], c["bg"], mode)
```

Some also compute local helper closures:

- `renderers_extra_shell.py`: has `g(key)` that does `guard(c[key], bg, mode)`
- `renderers_extra_btop.py`: explicitly guards each variable one by one
- `renderers_extra_bat_delta.py`: has `g(color)` that does `guard(c[color], bg, mode)`

**Fix**: Could provide a `make_guard(bg, mode)` factory or a `g(key)` helper via palette.py.

#### 3. `opencode_tokens()` — shared but called directly

`opencode_tokens()` is shared by `renderers_opencode.py`, `renderers_codex.py`, and `renderers_pi.py`. The function itself has repetitive `guard()` calls — 17+ calls that vary only by palette key and minimum ratio:

```python
keyword = guard(c["accent"], c["bg"], mode_name, minimum=syntax_min)
function = guard(c["accent_2"], c["bg"], mode_name, minimum=syntax_min)
type_color = guard(c["diagnostic"], c["bg"], mode_name, minimum=syntax_min)
method = guard(c["accent_2"], c["bg"], mode_name, minimum=syntax_min)
# ... 13 more
```

This is fine as-is, but the function body is 50+ lines of repetitive dict building.

#### 4. `sync_repo_snippets()` — extreme repetition (~270 lines)

The function repeatedly calls `write_variant_files()` with nearly identical args. The pattern is:

```python
repo_changes += write_variant_files(
    ROOT / "DreamcoderX",
    {k: f"filename-{v}.ext" for k, v in mode_names.items()},
    content_builder,
    variants,
)
```

Then a separate:

```python
repo_changes.append(
    write_if_changed(ROOT / "DreamcoderX/active.ext", content_builder(active))
)
```

This pattern repeats **20+ times** with just 3 varying parameters: directory name, filename template, and content builder function. Could be reduced to a data-driven loop.

#### 5. `renderers_codex.py` — thin wrapper

The module is 53 lines total, 50 of which is a single f-string XML template. Its one function `codex_tmtheme_content()` calls `opencode_tokens()` and formats XML. Could be folded into another module.

#### 6. `renderers.py` — 65-line import hub

Currently re-exports 30 functions. Importing any renderer transitively imports all leaf modules. Not a performance issue (no heavy imports), but unnecessary coupling.

### Affected Areas

| File                                                | Why Affected                                             |
| --------------------------------------------------- | -------------------------------------------------------- |
| `src/dreamcoder_theme/palette.py`                   | Add `detect_mode()` export; optionally add guard factory |
| `src/dreamcoder_theme/renderers_opencode.py`        | Consolidate to use shared `detect_mode()`                |
| `src/dreamcoder_theme/renderers_codex.py`           | Potentially merge into another module                    |
| `src/dreamcoder_theme/renderers_pi.py`              | Consolidate to use shared `detect_mode()`                |
| `src/dreamcoder_theme/renderers_extra_shell.py`     | Remove local `_mode()` in favor of shared                |
| `src/dreamcoder_theme/renderers_extra_bat_delta.py` | Remove local `_detect_mode()` in favor of shared         |
| `src/dreamcoder_theme/renderers_extra_btop.py`      | Remove inline mode detection                             |
| `src/dreamcoder_theme/renderers_starship.py`        | Remove inline mode detection                             |
| `src/dreamcoder_theme/sync.py`                      | Major: replace repetitive variant-file loop              |
| `src/dreamcoder_theme/writers.py`                   | Add helper to combine variant + active write             |
| `src/dreamcoder_theme/renderers.py`                 | Minor: add/remove re-exports                             |
| `tests/test_dreamcoder_writers.py`                  | Tests for new writer helpers                             |
| `tests/test_dreamcoder_sync.py`                     | Tests for sync changes                                   |
| `tests/test_dreamcoder_theme_quality.py`            | Potentially affected by guard changes                    |

### Approaches

1. **Minimal consolidation** — extract `detect_mode()` to palette.py, clean up sync_repo_snippets into data loop, remove inline mode detections.
   - Pros: No behavioral change, focused diff, easy to review
   - Cons: Doesn't address deeper abstractions
   - Effort: Medium

2. **Full refactor** — approach 1 + guard factory in palette.py, consolidate codex.py into opencode module, restructure sync_repo_snippets with a declarative variant registry.
   - Pros: Architecture improvements, more DRY, testable registry
   - Cons: Larger diff, higher risk of missing edge cases
   - Effort: High

3. **Targeted data-driven refactor** — approach 1 + sync registry. The highest-value change is the sync.py repetition. Skip consolidating thin wrappers.
   - Pros: High impact-to-risk ratio, biggest payoff in maintainability
   - Cons: Still misses unification of codex/pi renderers
   - Effort: Medium

### Recommendation

**Approach 3 (Targeted data-driven refactor)** is the best balance. The sync.py repetition is the biggest maintenance burden (~270 lines of boilerplate that could be ~40 lines of data). Fix mode detection duplication across renderers as a mechanical cleanup. Skip consolidating codex.py for now — it's small and its existence documents the separation of concerns.

### Risks

- Missed `detect_mode()` location — need to grep all renderer modules thoroughly
- `sync_repo_snippets()` data loop must preserve the exact order of writes since later writes depend on earlier directory structure
- `write_variant_files()` API is stable; a combined `write_variant_files_and_active()` helper must not break existing callers in `sync_bat_theme_variants()`
- No existing tests for `sync_repo_snippets()` or `sync_active_targets()` — changes risk regression
- The 3 callers of `opencode_tokens()` must continue to get the same return dict
- `palette.detect_mode()` already exists but is never used — this is a smell of prior reluctance to consolidate

### Ready for Proposal

Yes. The exploration is complete and the consolidation paths are clear. The orchestrator should:

1. Run the proposal phase with Approach 3 (Targeted data-driven refactor) as recommendation
2. Flag that new sync helper tests should be added
3. Confirm the existing `detect_mode()` in palette.py is the right shared implementation
