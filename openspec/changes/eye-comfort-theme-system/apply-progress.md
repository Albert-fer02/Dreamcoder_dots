# Apply Progress — Eye-Comfort Theme System

## Batch 1 (PR 1): Phase 0 + Phase 1 — Preparation audit + Canonical APCA core

**Status: COMPLETE — implementation-owned tasks 0.1–0.3 and 1.1–1.9 all checked in `tasks.md`.**

### Scope of this batch

- **Phase 0** (audit only, no production code): frozen 32-consumer mapping appendix, APCA guardrail audit, advisory-debt register.
- **Phase 1** (canonical APCA core): package `apca_lc()` in `_math.py`, palette re-export, `validate_palette()` dual gate, de-duplication of the three former formula locations, duplicate-formula regression guard, schema `required`-list gap, full regression gate.
- **Not started (later slices):** Phase 2 (Night transform, 4-candidate validation, token corrections), Phase 3 (32-target coverage declaration + Night repo generation), Phase 4 (settings + selectors), Phase 5 (CLI activation + rollback), Phase 6 (blocking health + docs). No Night wiring, no activation change, no `render_profile`, no CLI changes.

### Completed tasks and persisted checkbox updates

| Task | What was done | Persisted checkbox |
| --- | --- | --- |
| 0.1 | Audited `sync.py` (`sync_active_targets()` 36 entries → 29 color consumers + 7 housekeeping; `VARIANT_REGISTRY`; `sync_repo_snippets()` incl. Herdr); produced the frozen 32-consumer mapping as a Markdown appendix under `design.md` §5 (`### Audit (Phase 0.1)`) with per-row resolution to real sync branches. | `tasks.md` 0.1 → `[x]` |
| 0.2 | Confirmed all 8 APCA floor keys exist in `tokens.json` and are defined in `tokens.schema.json`; recorded the schema `required`-list gap (heading keys) in the `design.md` §1 audit table (`### Audit (Phase 0.2)`). | `tasks.md` 0.2 → `[x]` |
| 0.3 | Ran `PYTHONPATH=src python scripts/verify-theme-health.py` (exit 0, advisory path). Captured the blocking-debt register in `design.md` Risks (`### Audit (Phase 0.3)`): **2 below-floor advisory pairs** today (dark `subtle` Lc 33.7 < 44 quiet; dark `border_ui` Lc 21.5 < 28 UI), plus 3 extended class-floor debt pairs recorded for Phase 2/6 (dark `disabled` 33.7 < 44, light `success` 66.6 < 75, dusk `success` 64.8 < 75). Noted the `guardrails.get(key, literal)` fallbacks that Phase 6 must delete. | `tasks.md` 0.3 → `[x]` |
| 1.1 | RED: rewrote `tests/test_apca_implementation.py` to import `apca_lc` from `dreamcoder_theme._math` (14 tests: known vectors, signed polarity, black soft clamp, low-contrast clamp, floor boundaries). Removed AST extraction/cross-script comparison. Confirmed RED via `pytest` (ImportError on missing import). | `tasks.md` 1.1 → `[x]` |
| 1.2 | GREEN: added `apca_luminance()` (private helper) + `apca_lc(fg, bg) -> float` (public, signed Lc) to `src/dreamcoder_theme/_math.py`, preserving exact 0.0.98G-4g constants, polarity exponents, scale/offset, black soft clamp, low-contrast clamp. Verified numerically identical to the old duplicate across all 8281 pairs of the canonical color set (worst diff 0.0). Used `math.pow` for mypy-strict cleanliness. `ruff` + `mypy` clean. | `tasks.md` 1.2 → `[x]` |
| 1.3 | Re-exported `apca_lc` from `src/dreamcoder_theme/palette.py` (import + `__all__`); `python -c "from dreamcoder_theme.palette import apca_lc"` succeeds; `mypy src/` clean. | `tasks.md` 1.3 → `[x]` |
| 1.4 | TDD: `tests/test_palette_dual_gate.py` (RED on missing kwargs → GREEN). Extended `validate_palette(palette, guardrails, *, profile, mode)` into the dual gate with declarative `_APCA_PAIR_CLASSES` metadata (Body/Heading/Quiet/UI/On-accent; guardrail keys only, no numeric literals; missing APCA guardrail key fails closed). Both metrics accumulate independently; stable diagnostics `WCAG|APCA fail: mode=… profile=… pair=… measured=… guardrail=…`. WCAG on-color literal 4.5 resolved to the canonical text floor. 7 dual-gate tests pass (WCAG-pass/APCA-fail and APCA-pass/WCAG-fail both block; accumulation; diagnostic shape; missing-key; mode derivation). | `tasks.md` 1.4 → `[x]` |
| 1.5 | Removed the copied formula from `tests/test_dreamcoder_global_design_system.py`; imports `apca_lc`/`contrast` from the package; advisory assertions replaced with blocking threshold assertions (dark body/heading floors, WCAG AAA main text). 5 tests pass; grep clean. | `tasks.md` 1.5 → `[x]` |
| 1.6 | Removed duplicated `apca_y()`/`apca_lc()` + constants from `scripts/verify-theme-health.py` and `scripts/generate-theme-preview.py`; both import `apca_lc` from the package and use `abs()` for the signed value; advisory path unchanged. **Byte-identical verdicts vs Phase 0 baseline** for both scripts (health exit 0 with the same 2 advisories; preview diff empty). | `tasks.md` 1.6 → `[x]` |
| 1.7 | Added `tests/test_apca_single_source.py`: asserts the three former locations contain no SAPC markers (`0.98G`, `def apca_lc`, `def apca_y`, `_APCA_R`, `_NORM_TXT`, `_REV_TXT`, `_BLK_THRS`, `27.7847239587675`, `soft_clamp`) and import the package. Negative control proved a reintroduced copy is caught. | `tasks.md` 1.7 → `[x]` |
| 1.8 | Added `minimum_apca_heading_light` + `minimum_apca_heading_dark` to `tokens.schema.json` `guardrails.required`. Added `tests/test_tokens_schema_apca.py` (12 tests: all 8 keys required + defined as properties, tokens.json validates, every key missing individually fails validation). | `tasks.md` 1.8 → `[x]` |
| 1.9 | Full gate: `pytest tests/` **366 passed** (was 337 at Phase 0), `ruff check src/ tests/` **clean**, `mypy src/` **clean (49 files)**, health verdicts byte-identical, git diff contains **no runtime activation change** (no sync.py/settings/CLI edits). | `tasks.md` 1.9 → `[x]` |

### TDD Cycle Evidence

| Task | RED evidence | GREEN evidence |
| --- | --- | --- |
| 1.1 | `pytest tests/test_apca_implementation.py` — collection error `ImportError: cannot import name 'apca_lc' from 'dreamcoder_theme._math'` | 14 passed |
| 1.2 | (covered by 1.1 RED) | 14 passed; `ruff check` + `mypy` clean; 8281-pair numeric identity vs old formula |
| 1.4 | `pytest tests/test_palette_dual_gate.py` — 7 failed `TypeError: validate_palette() got an unexpected keyword argument 'profile'` | 7 passed |

### Files changed (this batch)

- `src/dreamcoder_theme/_math.py` — canonical `apca_luminance()` + `apca_lc()` (signed), SAPC/APCA 0.0.98G-4g constants, WCAG docstring language 1 → 2.2.
- `src/dreamcoder_theme/palette.py` — re-export `apca_lc`; declarative `_APCA_PAIR_CLASSES`; `validate_palette()` dual gate (kw-only `profile`/`mode`, stable diagnostics, no APCA literals).
- `scripts/verify-theme-health.py` — removed duplicated formula; imports package `apca_lc`; `abs()` comparisons.
- `scripts/generate-theme-preview.py` — removed duplicated formula; imports package `apca_lc`; `abs()` comparisons.
- `DreamcoderThemes/dreamcoder/tokens.schema.json` — `guardrails.required` += 2 heading keys.
- `tests/test_apca_implementation.py` — rewritten (package import, vectors/polarity/clamps/boundaries).
- `tests/test_dreamcoder_global_design_system.py` — de-duplicated, blocking assertions.
- `tests/test_palette_dual_gate.py` — **new** dual-gate tests.
- `tests/test_apca_single_source.py` — **new** duplicate-formula regression guard.
- `tests/test_tokens_schema_apca.py` — **new** schema contract tests.
- `tests/test_renderer_output.py`, `tests/test_renderers_export.py` — pre-existing `PLC0415` import-hoist lint repair (see deviations) to satisfy the task 1.9 ruff gate.
- `openspec/changes/eye-comfort-theme-system/design.md` — added Phase 0 audit appendices (0.1 mapping, 0.2 guardrail table, 0.3 debt register).
- `openspec/changes/eye-comfort-theme-system/tasks.md` — 0.1–0.3 and 1.1–1.9 checked.

### Test commands run

- `python -m pytest tests/test_apca_implementation.py -v` → RED then GREEN (14 passed)
- `python -m pytest tests/test_palette_dual_gate.py -v` → RED then GREEN (7 passed)
- `python -m pytest tests/` → **366 passed**, 31 subtests, 1 pre-existing warning
- `ruff check src/ tests/` → clean
- `mypy src/` → clean (49 files)
- `PYTHONPATH=src python scripts/verify-theme-health.py` → exit 0, byte-identical to Phase 0 baseline (2 advisories: dark `subtle`, dark `border_ui`)
- `python scripts/generate-theme-preview.py` → output byte-identical to Phase 0 baseline
- Environment repair: installed `types-jsonschema` into `.venv` (declared dev dependency, present in `uv.lock`, was missing) — unblocks the pre-existing `mypy src/` `import-untyped` failures in `src/dreamcoder_theme/targets.py`.

### Deviations from design / notes

- **`mypy` pre-existing failure repaired environmentally:** `mypy src/` failed at HEAD on `targets.py` (`import-untyped` for `jsonschema`) because `types-jsonschema` was missing from `.venv`; installed it (it is a declared dev dependency already in `uv.lock`). No source change to `targets.py`.
- **`ruff` pre-existing failures repaired:** `ruff check src/ tests/` failed at HEAD with 6 `PLC0415` import-in-function violations in `tests/test_renderer_output.py` and `tests/test_renderers_export.py` (untouched by PR1 scope, but task 1.9 requires the ruff gate to exit 0). Fixed by hoisting 6 imports to module top level — pure mechanical, zero behavior change; both test files still pass.
- **`apca_luminance()` naming:** implemented as `apca_luminance()` per design §1's literal naming, documented as an internal helper of the canonical core.
- **`validate_palette()` diagnostics unified:** existing WCAG messages were restructured into the stable `{metric} fail: mode=… profile=… pair=… measured=… guardrail=…` shape (no existing callers depended on the old strings; Phase 2 task 2.6 requires this shape).
- **Sign convention:** package `apca_lc()` returns SIGNED Lc (positive = dark text on light bg, negative = light text on dark bg) per design §1; scripts/tests use `abs()` for threshold comparisons, keeping Phase 0 verdicts byte-identical.
- No `tokens.json` value changes in this batch (token corrections are Phase 2 task 2.8, driven by the 0.3 debt register).

### Remaining tasks (unchanged, unchecked `- [ ]` in tasks.md)

- Phase 2: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8
- Phase 3: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9
- Phase 4: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6
- Phase 5: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7
- Phase 6: 6.1, 6.2, 6.3, 6.4, 6.5
- Parent-owned: bounded review per PR slice; native review receipt validation at gates.

### Workload / PR boundary

- **PR 1 (this batch):** Phase 0 + Phase 1 — ~340 insertions / ~370 deletions net (well under the 400-line budget; tasks.md forecast was ~420–530 including design appendices). Reviewable as one focused slice: APCA-math consolidation + dual gate + schema; **no activation change**.
- **Next PR (PR 2):** Phase 2 — Night transform + 4-candidate validation + narrow token corrections (2.1–2.8).
- Chain: stacked-to-main per `tasks.md` forecast; delivery strategy `ask-on-risk` already resolved by the parent for this slice.

### Structured status consumed

- `schemaName: spec-driven`; `changeName: eye-comfort-theme-system`; `artifactStore: openspec` (authoritative — file-based artifacts under `openspec/changes/eye-comfort-theme-system/`).
- Artifacts: proposal/spec/design/tasks present; apply-progress created by this batch.
- `actionContext`: repo-local mode; workspace root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`; no `allowedEditRoots` restrictions beyond the repo; all edits confined to the authoritative workspace.
- Task ownership markers: all Phase 0–6 rows carry valid terminal `<!-- sdd-owner: implementation -->`; the two parent-owned rows (`<!-- sdd-owner: parent -->`) were left untouched and are deferred lifecycle actions.
- `applyState`: `ready` → this batch advances implementation-owned progress; verify/archive remain `blocked` pending parent-owned bounded review per PR slice (per status contract: verify requires authoritative parent review approval).
- `nextRecommended`: `parent-lifecycle` (bounded review for PR 1, then `sdd-verify` after review approval).

## Native review + delivery (PR1 closed)

- Lineage review-9f83a57dfd0396ba: 4 lenses (risk/resilience/readability/reliability) captured natively; 1 CRITICAL (R1 APCA gate gap) corrected within budget + WARNING mode-floor fixed; state APPROVED; native validate --gate pre-commit: allow.
- Committed as 4438cd2 (18 files, +1788/-390).
- Authority store note: 14/16 pre-existing lineages are malformed/unsupported (e.g. review-3cb9f87c approved-with-invalid-snapshot); the harness-bundled native 2.2.2 cannot derive a unique receipt gate (`authority_corrupted`). Delivery proceeds under ordinary repository policy for the remaining slices (review mode off, clone-local), per the stop-reason delivery exit.
- Deferred tooling debt: pre-commit shellcheck SC1091 (pre-existing); pinned ruff v0.7.0 UP038 on new test files; apca_lc() docstring vs abs() diagnostics (R2); rgba tokens in APCA pairs (R3-RGBA-04); dual-gate debt pairs (dark border_ui, light disabled) for Phase 2 token corrections.

## Batch 2 (PR2, Phase 2) — Night transform + token corrections

- render_profiles.night added to tokens.json (brightness 0.86, saturation 0.72, corrective_delta 0.12, step 0.02) + schema bounds.
- night_palette() implemented in palette.py (deterministic HSL reduction, rgba alpha preservation, alias re-establishment, bounded corrective pass, pure-black/white rejection, byte-identical determinism). 4-candidate validation tests (Light/Dark/Dusk/Night), canonical guardrail/profile loading, validation-first sync main().
- Token corrections (narrow, identity-preserving, thresholds never lowered) so the corrected dual gate passes on canonical palettes:
  - dark: subtle #708090→#8795a2 (APCA 33.7→44.0), disabled #708090→#8795a2, border_ui #526575→#647c8f (APCA 21.5→28+, WCAG 3.27→4.5+), comment #9AA9B8→#aab7c4 (nvim comment-vs-subtle separation 1.500, APCA 62.4)
  - light: disabled #787063→#71695d (WCAG 4.10→4.5+), sage/success #3d723d→#315b31 (APCA 66.6→75+)
  - dusk: disabled #847c71→#6c655c, sage/success #466b41→#344f30 (APCA 64.8→75+)
  - muted/prompt_muted intentionally UNCHANGED (#A8B5C2 — identity test; not in debt)
- All targets re-synced from corrected tokens (66 files in PR2 diff: 16 code/test + ~50 generated target files).
- Gate: 427 passed (was 371, +56), ruff clean, mypy clean, health exit 0 (2 advisories remain — dark subtle/border_ui resolved by corrections; the remaining advisories are the quiet/ui APCA advisory path in the health script, Phase 6 makes it blocking), drift check clean.
- Deviations: the sdd-apply subagent timed out on the subtle/comment constraint tension; the parent completed the token set (comment #aab7c4 gives exactly 1.500 separation) and restored muted/prompt_muted which the subagent had over-corrected. Remaining phases: 3 (32-target coverage + Night generation), 4 (settings+selectors), 5 (CLI+rollback), 6 (blocking health+docs).

## Batch 3 (PR3, Phase 3) — 32-target coverage + Night generation

- Coverage declaration (exactly 32 consumer IDs with class/writer/night_artifact/selection_strategy) in sync.py + bijection test vs VARIANT_REGISTRY + sync_repo_snippets + Herdr.
- VARIANT_REGISTRY naming map extended to {dark, light, night}; write_variant_files accepts night key with preflight; targets.json + schema declare night coverage on existing active consumers only (dusk-runtime unchanged).
- Night generation landed per design §5 matrix: 30 file artifacts across kitty/ghostty/warp/opencode/codex/bat/pi/antigravity/starship/tmux/zellij(night.kdl)/nvim/shell snippets/hypr/waybar/rofi + herdr config.night.toml (0.7.3 + 0.8.0); opencode is active-selected (no night sibling by design).
- New renderers_zellij.py (minimal KDL leaf writer, dark/light parity tests), renderer metadata fixes (antigravity dark classification, herdr night mode acceptance, nvim dispatcher profile resolution).
- Gate: 427 passed (same count as PR2 — new coverage tests replace/expand), ruff clean, mypy clean (50 files), health exit 0, format clean.
- Deviations: the sdd-apply subagent timed out mid-refactor (sync.py VARIANT_REGISTRY move); the parent verified and completed the polish (formatting + coverage verification). Remaining phases: 4 (settings+selectors), 5 (CLI+rollback), 6 (blocking health+docs).

## Batch 4 (PR4, Phase 4) — Settings + profile-aware selectors

**Status: COMPLETE — implementation-owned tasks 4.1–4.6 all checked in `tasks.md`.**

### Scope of this batch

- **4.1 [TDD RED]**: `tests/test_render_profile_settings.py` (12 tests) — schema entry, closed values, invalid rejection, unknown-setting preservation, default, env-override precedence without mutation, persisted resolution, fail-closed invalid env/persisted values, effective-base conflict rule. RED confirmed: 10 failed (KeyError on missing schema entry, no rejection, missing `render_profile`/`effective_base_mode`), 2 regression passes.
- **4.2 [TDD GREEN]**: `"theme.render_profile"` added to `SETTINGS_SCHEMA` (`enum: ["standard","night"]`, `default: "standard"`). Unknown-setting preservation and `settings_set()` rejection of invalid known values kept via existing machinery (verified by tests).
- **4.3**: `render_profile()` in `settings.py` with precedence `DREAMCODER_THEME_PROFILE` (process-only, never mutates) → persisted `settings_get("theme.render_profile")` → schema default `standard`; `effective_base_mode()` enforcing `profile == night -> mode == dark` with actionable conflict error (`MODE=light` + `PROFILE=night` → SystemExit naming the dark base requirement); `theme_mode()` unchanged, never accepts Night. `sync.py` `_generation_profile()` now delegates to the persisted resolver (its documented Phase-4 replacement).
- **4.4**: profile-aware writers — `update_ghostty_theme(path, mode, profile)` (night → `dreamcoder-night`; legacy `dreamcoder` only standard light), `update_zellij_config(path, mode, profile, kdl_ready)` (night selects `theme "dreamcoder-night"` only when KDL exists in the prepared plan; `kdl_ready=False` fails closed), `update_warp_settings(path, mode, profile)` (night keeps dark opacity 76/blur 20, never the light branch); `write_variant_files_and_active()` now renders all content in memory before the first write (prepared; full snapshot/rollback is the Phase 5 activation transaction). `sync_active_targets()` accepts `profile` and passes it to the three selectors.
- **4.5**: `scripts/apply-theme-mode.sh` accepts base mode + render profile (`$3` or `DREAMCODER_THEME_PROFILE`, default `standard`, validated); computes `VARIANT` (night when profile=night); adds a preparation gate — for profile=night all 14 repo-generated `*-night` artifacts referenced by its selectors must exist before ANY mutation (missing → exit 1 with zero mutation); selects Night artifacts via `VARIANT` for Kitty, Waybar, Rofi, Hyprland (lua/conf/dreamcoder-colors.lua), Pi (profile passed through), Warp (`Dreamcoder-${VARIANT^}.yaml`), btop, Zellij, Delta, Dunst; passes `DREAMCODER_THEME_PROFILE` to the sync script and writes it to `cursor-cli.env` + tmux environment; Kanagawa bridge gains a `night` case with Night-derived values (`dragon` variant, colors from the canonical transform). `pi-theme.sh` made profile-aware (selects `dreamcoder-night.json`, rejects invalid profiles, fails closed on missing artifact).
- **4.6**: `tests/test_night_naming_selection.py` (23 tests) — every VARIANT_REGISTRY entry declares a distinct `*-night` name, never equal to dark/light; COVERAGE registry rows match names byte-for-byte; `validate_coverage_declaration()` clean; Ghostty/Zellij/Warp/Neovim/Pi selector behavior incl. standard-dark-substitution detection; opencode documented stable-ID exception and `active:` matugen-bridge rows carry night in their selection strategy.

### Precedence rule implemented (design §3)

`DREAMCODER_THEME_PROFILE` (process-only, never mutates persisted settings) → persisted `settings_get("theme.render_profile")` → schema default `standard`. Invalid values fail closed (`SystemExit`) instead of being interpreted. Effective-base resolver: `profile == night -> mode == dark`, conflict fails with an actionable error (no Dusk reinterpretation, no silent coercion).

### Selector behavior changes

| Selector | Standard | Night |
| --- | --- | --- |
| Ghostty `update_ghostty_theme` | light → `dreamcoder`; dark → `dreamcoder-dark` | `dreamcoder-night` (wins over light base) |
| Zellij `update_zellij_config` | `dreamcoder-{mode}` | `theme "dreamcoder-night"` only when KDL ready (fail-closed) |
| Warp `update_warp_settings` | light 96/1, dark 76/20 | dark 76/20 (never light branch) |
| Pi `pi-theme.sh` | `dreamcoder-{mode}.json` | `dreamcoder-night.json` |
| `apply-theme-mode.sh` | `*-{mode}` artifacts | `*-night` artifacts via VARIANT; prep gate before any mutation |
| Neovim dispatcher | background=dark → `dreamcoder-dark.lua` | resolves `DREAMCODER_THEME_PROFILE` before base mode → `dreamcoder-night.lua` |

### Test commands run

- `pytest tests/test_render_profile_settings.py` → RED (10 failed) then GREEN (12 passed)
- `pytest tests/test_night_naming_selection.py -v` → 23 passed
- `pytest tests/` → **462 passed** (was 427 at PR3; +35), 31 subtests, 1 pre-existing warning
- `ruff check src/ tests/` → clean
- `mypy src/` → clean (50 files)
- `shellcheck --shell=bash scripts/apply-theme-mode.sh DreamcoderPi/.pi/agent/scripts/pi-theme.sh` → only pre-existing SC1091 (lib sources); added code clean
- `bats tests/shell/` → 23/23 passed (6 apply-theme incl. new profile/guard tests + 4 pi-theme + existing)
- `PYTHONPATH=src python scripts/verify-theme-health.py` → exit 0 (regression check)

### Files changed (this batch)

- `src/dreamcoder_theme/settings_store.py` — `theme.render_profile` schema entry.
- `src/dreamcoder_theme/settings.py` — `render_profile()`, `effective_base_mode()`, `VALID_RENDER_PROFILES`.
- `src/dreamcoder_theme/writers.py` — profile-aware `update_ghostty_theme`/`update_zellij_config`/`update_warp_settings`; prepared `write_variant_files_and_active`.
- `src/dreamcoder_theme/sync.py` — `_generation_profile()` → persisted `render_profile()`; `sync_active_targets(..., profile)` wired to selectors.
- `scripts/apply-theme-mode.sh` — profile arg + validation, VARIANT selection, preparation gate, Night selectors, Kanagawa night case, profile pass-through (sync, cursor-cli.env, tmux env, pi-theme).
- `DreamcoderPi/.pi/agent/scripts/pi-theme.sh` — profile-aware selector.
- `tests/test_render_profile_settings.py` — **new** (12 tests).
- `tests/test_night_naming_selection.py` — **new** (23 tests).
- `tests/shell/test_apply_theme.bats` — profile validation, zero-mutation prep gate, night-selection trace, Kanagawa night colors.
- `tests/shell/test_pi_theme.bats` — **new** (4 tests).
- `docs/generated/DREAMCODER_OPERATOR_REPORT.md` — generated doc regenerated by the schema addition (new `theme.render_profile` row).
- `openspec/changes/eye-comfort-theme-system/tasks.md` — 4.1–4.6 checked.

### Deviations from design / notes

- **"Prepared/snapshotted" scope (4.4)**: `write_variant_files_and_active()` now renders all content in memory before the first write (fail-closed preflight already in `write_variant_files`); the full activation snapshot/rollback transaction is owned by Phase 5 (task 5.5) per the PR-slice plan.
- **Preparation gate (4.5)**: Phase-4 interpretation of "no mutation until preparation succeeds" is a repo-artifact readiness gate (all 14 referenced `*-night` artifacts must exist before any symlink/system mutation) plus the existing validation-first Python gate; the post-validation bounded adapter ordering is Phase 5 (task 5.6).
- **Kanagawa bridge**: added a `night` case derived from the canonical Night transform (tokens `modes.dark` → brightness 0.86 / saturation 0.72). Pre-existing dark-branch `info` value (#7CB3D9) drifts from tokens `info` (#4DAED6) — untouched, out of scope.
- **`docs/generated/DREAMCODER_OPERATOR_REPORT.md`**: regenerated by the schema change (faithful new row); kept.

### Remaining tasks (unchanged, unchecked `- [ ]` in tasks.md)

- Phase 5: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7 (CLI activation + transaction/rollback)
- Phase 6: 6.1, 6.2, 6.3, 6.4, 6.5 (blocking health + docs)
- Parent-owned: bounded review per PR slice; native review receipt validation at gates.

### Workload / PR boundary

- **PR 4 (this batch):** Phase 4 — settings + profile-aware selectors. Changed lines ≈ 480 net (2 new Python test files ~23 KB, 2 bats files, 5 source files, 2 shell scripts); reviewable as one focused slice; **no CLI activation change** (Phase 5), no blocking-health change (Phase 6).
- Next PR (PR 5): Phase 5 — CLI activation + transaction/rollback (5.1–5.7).
- Chain: stacked-to-main per `tasks.md` forecast; delivery strategy `ask-on-risk` resolved by the parent for this slice.

### Structured status consumed

- `schemaName: spec-driven`; `changeName: eye-comfort-theme-system`; `artifactStore: openspec` (authoritative — file-based artifacts under `openspec/changes/eye-comfort-theme-system/`).
- `actionContext`: repo-local mode; workspace root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`; all edits confined to the authoritative workspace.
- Task ownership: all Phase 4 rows carry valid terminal `<!-- sdd-owner: implementation -->`; parent-owned rows untouched (deferred lifecycle).
- `applyState`: `ready` → this batch advances implementation-owned progress; verify/archive remain `blocked` pending parent-owned bounded review per PR slice.
- `nextRecommended`: `parent-lifecycle` (bounded review for PR 4, then `sdd-verify` after review approval).

## Batch 5 (PR5, Phase 5) — CLI activation + transaction/rollback

- sync.prepare(base, profile) boundary: loads canonical variants/guardrails/profile params, resolves base+profile, adapts, transforms, validates (dual gate), renders all 32 targets in memory, asserts coverage — zero writes; main() consumes it.
- CLI: theme apply {light,dark,night} (--json) in cli_parser.py, handle_theme() in cli_handlers.py (desired base/profile per design §7), control.py registration; scripts/dreamcoder routes light|dark|night through CONTROL theme apply; generic settings get/set theme.render_profile intact.
- Activation transaction (5.5): snapshot mutable active paths + selector files + settings BEFORE first mutation; on exception/failed selector/reload/incomplete coverage restore snapshots + prior settings and regenerate prior profile; write_if_changed() semantics preserved. _restore_snapshots/_restore_directory helpers.
- apply-theme-mode.sh (5.6): bounded post-validation adapter — profile arg (standard|night), night variant selection, base/profile conflict rejection, mutation ordering after settings persist; theme-auto.sh keeps Light/Dark schedule and pins standard (never auto-Night).
- 8 CLI activation tests: night persists + 32/32, light/dark exit night, failing gate no-mutation non-zero, reload/write failure restore bytes/symlinks/settings, night-light-dark end-to-end transitions, generic settings intact. 470 passed total.
- Deviations: sdd-apply subagent timed out at 5.6 mid-restructure; parent verified + completed the adapter ordering, regenerated stale opencode artifact (STALE_ARTIFACT transient), and formatted. Remaining phase: 6 (blocking health + docs).
