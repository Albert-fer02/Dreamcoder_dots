# Apply Progress: Repair Dreamcoder Theme Rollout

## Status

- **state:** blocked
- **slice / PR boundary:** Slice 1 only — runtime evidence gate (stacked-to-main, auto-chain)
- **runtime gate:** `pending`; do not begin Slice 2.
- **structured status consumed:** `applyState=ready`; `actionContext.mode=repo-local`; allowed edit root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- **action-context warning:** Existing unrelated workspace modifications were preserved. No external config was edited.

## Completed Implementation Tasks

The four Slice 1 implementation tasks are visibly marked `[x]` in `tasks.md`:

1. Sanitized runtime inspection completed.
2. Version-tied CLI/help, process, selection, validator, and reload evidence captured without config contents.
3. Created `runtime-inspection.md` with `state: pending` and explicit title-field dispositions.
4. Confirmed the record is reviewable and remains non-confirmed because required facts are unverifiable.

## Files Changed

- `openspec/changes/repair-dreamcoder-theme-rollout/runtime-inspection.md`
- `openspec/changes/repair-dreamcoder-theme-rollout/tasks.md`
- `openspec/changes/repair-dreamcoder-theme-rollout/apply-progress.md`

## Verification Evidence

Read-only local inspection completed:

- resolved `herdr`, recorded a digest, version `0.7.3`, platform, and sanitized provenance result;
- inspected metadata only for the active, Dark, and Light candidates;
- checked only relevant field-name presence, with no config values captured;
- queried `herdr --help`, `herdr config --help`, `herdr server reload-config --help`, and `herdr status --help`;
- checked named-process presence and searched documented Herdr logs only for the three relevant diagnostic terms.

No test suite ran: this evidence-only slice changed no production code. No config validation, reload, restart, or external-file mutation was performed.

## Gate Result and Deviation

No design deviation. The record is intentionally `pending`, not `confirmed`: the current executable and process were observed, but the screenshot errors cannot be authoritatively attributed to Herdr, its actual parsed config remains unverified because the documented override was not inspected, and no authoritative schema/validator or reload exit contract was available. `window-title` and `tab-title` remain unsupported/unverified and must not be emitted or replaced.

## Remaining Implementation Tasks

- [ ] Add focused Python tests under `tests/` for the confirmed profile: deterministic Light/Dark output, canonical token mapping and palette guardrails, omission or exact supported representation of title behavior, runtime/profile preflight rejection, and both variants being written through the existing one-argument renderer convention. <!-- sdd-owner: implementation -->
- [ ] Implement the repository compatibility profile/constants and preflight using only the confirmed runtime record; fail closed for unknown, incomplete, or unsupported versions before invoking `herdr_content(palette: dict)`. <!-- sdd-owner: implementation -->
- [ ] Implement `src/dreamcoder_theme/renderers_herdr.py` with `herdr_content(palette: dict) -> str`, export it from `src/dreamcoder_theme/renderers.py`, and emit only evidence-confirmed fields with deterministic trailing-newline output and no independent palette. <!-- sdd-owner: implementation -->
- [ ] Update only confirmed live/variant paths in `src/dreamcoder_theme/settings.py` and integrate both canonical `dark` and `light` variants in `src/dreamcoder_theme/sync.py` using existing `write_variant_files`/`write_if_changed` conventions. Do not add activation, migration, installer ownership, or reload behavior in this slice. <!-- sdd-owner: implementation -->
- [ ] Verify generated Dark and Light candidates with the recorded runtime validator before activation, run `python -m pytest tests/ -v`, and run `python scripts/verify-theme-health.py`; capture evidence that existing targets remain healthy and both variants are reproducible. <!-- sdd-owner: implementation -->
- [ ] Refactor only for existing renderer, settings, sync, naming, and test conventions while keeping the confirmed schema and one-argument renderer contract unchanged; rerun the Slice 2 verification commands. <!-- sdd-owner: implementation -->
- [ ] Add installer and shell integration tests for missing/managed/external/broken-link ownership, backup/restore, invalid mode, absent executable, unsupported version, missing variants, validation failure, atomic switching in both directions, not-running success, reload failure with rollback, rollback failure, explicit/automatic convergence, and cleanup-before-aggregate-status behavior. <!-- sdd-owner: implementation -->
- [ ] Update `src/dreamcoder_theme/installer.py`, `scripts/dreamcoder-lib.sh`, and only sequencing-required `scripts/dreamcoder-maintenance.sh` together so managed Herdr variants are provisioned before activation, existing external files are backed up or safely declined, and the executable remains outside repository ownership. <!-- sdd-owner: implementation -->
- [ ] Replace `scripts/herdr-theme-switch.sh` behavior with the confirmed validation, profile check, atomic active-selector transaction, process detection, supported reload/restart, rollback, stable status lines, and exit semantics; never use guessed commands or regex TOML migration. <!-- sdd-owner: implementation -->
- [ ] Update `scripts/apply-theme-mode.sh` to capture Herdr status, finish unrelated work and cleanup, then emit truthful aggregate success/partial failure with nonzero status for installed-target failures; preserve automatic propagation through `scripts/theme-auto.sh` and adjust Fish startup only if the confirmed evidence requires it. <!-- sdd-owner: implementation -->
- [ ] Add operational documentation covering prerequisites, compatibility bounds, inspection evidence, switching, diagnostics/statuses, backup ID, rollback, absent/not-running behavior, and unsupported title behavior when applicable. <!-- sdd-owner: implementation -->
- [ ] Run shell syntax/static checks and `python -m pytest tests/ -v`; exercise fresh install and repair in isolated HOME/XDG fixtures, then validate both generated files and both Light→Dark and Dark→Light switches on the inspected Herdr version, including observable runtime reload and original-error absence. <!-- sdd-owner: implementation -->
- [ ] Exercise missing Herdr, invalid config, reload failure, rollback, Fish startup, automatic scheduling, and explicit switching; verify no temporary/partial selector survives and unaffected targets still complete. <!-- sdd-owner: implementation -->
- [ ] Run `pytest tests/ --cov=dreamcoder_theme --cov-fail-under=40` and `python scripts/verify-theme-health.py`; record sanitized outcomes in the verification report and confirm documented rollback restores the pre-change configuration. <!-- sdd-owner: implementation -->
- [ ] Refactor only after runtime acceptance to remove duplication while preserving status semantics, atomicity, backup safety, explicit/automatic convergence, and all documented rollback behavior; rerun the full Slice 3 verification evidence. <!-- sdd-owner: implementation -->

## Deferred Parent Lifecycle Actions

- Stop the chain because the Slice 1 gate is `pending`; route the consumer/schema evidence gap to a proposal correction or separate scope decision.
- Start or reuse the evidence-only bounded review and confirm its receipt before any next slice.
- Preserve the inspected profile and generated artifacts across boundaries; do not authorize Slice 2 without a confirmed runtime contract.

---

## Ghostty Slice 1 Addendum — 2026-07-16 UTC

### Corrected Combined Status

- **state:** blocked
- **slice / PR boundary:** Slice 1 only — Sanitized Ghostty Runtime Evidence Gate (stacked-to-main, auto-chain)
- **runtime gate:** `pending`; Slice 2 is not authorized.
- **structured status consumed:** `applyState=ready`; `actionContext.mode=repo-local`; allowed edit root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- **action-context warning:** no path outside the allowed root was edited; no active Ghostty configuration was mutated.
- **historical Herdr record:** the preceding Herdr inspection remains historical-only evidence and was not edited, repurposed, or used as Ghostty completion evidence. Its earlier checkbox claim does not match this Ghostty tasks artifact and is not relied on here.

### Completed Ghostty Tasks and Persisted Checkbox Evidence

The following implementation-owned tasks are visibly marked `[x]` in `tasks.md`:

- Apply only the next dependency-ready slice.
- Keep implementation limited to Ghostty and preserve Herdr history.
- Do not edit title fields or implement activation before a confirmed runtime gate.
- Resolve and sanitize the local Ghostty executable identity.
- Discover supported validation, schema/help, selection, and reload/restart procedures from local Ghostty help.
- Create the pending sanitized Ghostty runtime inspection artifact.

### Files Changed

- `openspec/changes/repair-dreamcoder-theme-rollout/ghostty-runtime-inspection.md`
- `openspec/changes/repair-dreamcoder-theme-rollout/tasks.md`
- `openspec/changes/repair-dreamcoder-theme-rollout/apply-progress.md`

### Evidence and Verification

- Inspected `/usr/bin/ghostty`, Ghostty `1.3.1-arch2`, local package provenance, and executable SHA-256 without recording raw configuration or environment data.
- Used only advertised local actions: `+validate-config`, `+show-config`, and `+edit-config` help/schema.
- Default validation exited `1` and reproduced the two unknown-field diagnostics.
- Resolved the installed Ghostty root to the repository-managed source; recorded only title line locations, directive counts, path type, and hash.
- Validated a disposable isolated copy with `+validate-config --config-file`; it exited `1`. The fixture was removed.
- The local file-open tracer is unavailable, and no advertised diagnostic exposes the full parsed path/include graph. The gate is therefore `pending`, not `confirmed`.
- No test suite ran: this evidence-only slice changed no production code.

### Deviations

No design deviation. The design requires a sanitized actual file-open/include trace; this host cannot provide one with its currently available locally advertised tooling. No guessed command, key, schema, or title replacement was used.

### Remaining Implementation Tasks

- [ ] Reproduce the parser diagnostic and trace the actual startup config/include graph using advertised diagnostics or an isolated read-only file-open trace; record parsed paths in observable order, resolved paths/types, ownership classification, and exact line locations for `window-title` and `tab-title`. <!-- sdd-owner: implementation -->
- [ ] In an isolated temporary XDG/HOME fixture, validate the complete observed graph and exercise the discovered selection and reload/restart behavior without mutating the real active configuration; record exit/output contracts and supported Light/Dark semantics. <!-- sdd-owner: implementation -->
- [ ] Record separate evidence-derived dispositions for `window-title` and `tab-title`, plus sanitized pre-correction hashes, limitations, and the condition that permits Slice 2; `confirmed` is allowed only when parsed source, schema, validation, activation, and ownership evidence are complete. <!-- sdd-owner: implementation -->
- [ ] Verify the artifact is reviewable without unrelated user data and proves actual parsed paths rather than repository search alone; if any required fact is unverifiable, leave `state: pending` or `rejected` and stop the chain. <!-- sdd-owner: implementation -->

### Workload / PR Boundary

Delivery path was resolved as `auto-chain`, `stacked-to-main`. This Slice 1 documentation-only boundary contains only the runtime inspection, task checkboxes, and cumulative progress. It stops before Slice 2.

### Deferred Parent Lifecycle Actions

- Do not authorize Slice 2 while `ghostty-runtime-inspection.md` remains `state: pending`.
- Start or reuse the bounded review transaction only for this immutable Slice 1 target.

---

## Ghostty Default-Title Remediation — Current Apply Batch

### Status

- **state:** implementation complete; ready for parent verification and lifecycle handling.
- **slice / PR boundary:** Single PR — Ghostty base-config title remediation (two deletions in one configuration file).
- **structured status consumed:** `applyState=ready`; `actionContext.mode=repo-local`; allowed edit root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- **action-context warning:** Existing unrelated workspace modifications were preserved. The remediation did not edit external runtime configuration; the active root is the managed repository symlink.
- **historical Herdr record:** All preceding Herdr sections remain historical and unchanged. They are not evidence for this Ghostty remediation.

### Completed Implementation Tasks and Persisted Checkbox Evidence

All nine implementation-owned Ghostty remediation tasks are visibly marked `[x]` in `tasks.md`. Parent-owned lifecycle rows remain byte-for-byte unchecked and deferred.

### Files Changed

- `DreamcoderGhostty/.config/ghostty/config` — deleted only `window-title = "Terminal"` and `tab-title = "Terminal"`.
- `openspec/changes/repair-dreamcoder-theme-rollout/tasks.md` — marked the nine completed implementation-owned rows `[x]`.
- `openspec/changes/repair-dreamcoder-theme-rollout/apply-progress.md` — appended this cumulative evidence without modifying historical Herdr content.

### Validation Evidence

- `ghostty --version`: `Ghostty 1.3.1-arch2`.
- Active config resolution: `~/.config/ghostty/config` resolves to `DreamcoderGhostty/.config/ghostty/config` in the allowed repository root.
- Before edit: the base config contained exactly one `window-title` assignment and one `tab-title` assignment, with no `config-file` directive. Default `ghostty +validate-config` exited `1` and reported `window-title: unknown field` and `tab-title: unknown field`.
- After edit: the same unmodified-environment command `ghostty +validate-config` exited `0` with no title-field or configuration-error diagnostic.
- An exact before/after file comparison shows only the two required deletions. The final config contains no `window-title`, `tab-title`, or replacement `title` assignment.

### Scope and Deferred Work

No theme files, includes, renderer/writer/sync/installer scripts, generated variants, palette files, runtime configuration outside the repository-managed symlink, Herdr paths, or other workspace files were modified or validated by this batch.

The broader Dreamcoder Light/Dark rollout remains deferred until the relevant parsed Ghostty configuration graph and ownership/include relationships are traceable and proven. Herdr remains excluded pending a separate approved change.

### Remaining Tasks

No implementation-owned task remains unchecked. Deferred lifecycle actions are the exact parent-owned unchecked rows in `tasks.md`.

### TDD Cycle Evidence

Strict TDD is disabled in `openspec/config.yaml`; no TDD cycle was required. The required real-runtime acceptance evidence was the baseline and post-edit `ghostty +validate-config` runs.

---

## Manifest and Readability Foundation — Slice 1 Scope Gate

### Status

- **state:** blocked before implementation.
- **slice / PR boundary:** requested Slice 1, stacked-to-main / auto-chain.
- **structured status consumed:** `applyState=ready`; `actionContext.mode=repo-local`; allowed edit root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- **action-context warning:** the worktree has extensive pre-existing changes, including untracked design-system implementation and tests plus unrelated generated-theme edits. They remain excluded from this batch and were not reset, staged, reformatted, or overwritten.

### Scope-Gate Result

No code, tests, manifest, schema, or task checkbox was changed in this batch. The requested task grouping is not a sub-400-line work unit: it combines the design's independently budgeted 1A manifest/schema/model, 1B inventory-parity adapters, and 1C token/readability diagnostics. The current untracked `design_system.py` alone is 382 lines, while `targets.py`, `targets.json`, and `targets.schema.json` do not exist; adding the requested manifest model, schema, audit fixtures, focused RED tests, parity integration, and health diagnostics would necessarily exceed the 400 authored-line ceiling.

### Proposed Split

1. **Slice 1A:** manifest/schema/model plus complete audited classification fixture and manifest-focused RED/GREEN/TRIANGULATE tests.
2. **Slice 1B:** renderer/generation/installer/activation/health inventory parity adapters and duplicate output/selector checks.
3. **Slice 1C:** token/generated parity and generic WCAG/APCA state-matrix diagnostics, retaining the pre-existing dirty-baseline exclusion.

### Commands and Results

- `git status --short && git diff --stat` — confirmed extensive pre-existing dirty baseline; no mutation made.
- `wc -l src/dreamcoder_theme/design_system.py scripts/verify-theme-health.py tests/test_design_system_contract.py tests/test_theme_health.py` — 1,374 existing lines across adjacent pre-existing scope; `design_system.py` is 382 lines.
- Existence checks — `src/dreamcoder_theme/targets.py`, `DreamcoderThemes/dreamcoder/targets.json`, and `DreamcoderThemes/dreamcoder/targets.schema.json` are absent.

No test command was run because no RED test can be authored within the approved work-unit boundary without first selecting the proposed split. No design deviation was made.

### Remaining Implementation Tasks

- [ ] Add failing tests for manifest schema, complete audited classification, duplicate output/selector ownership, runtime `dusk` exclusion, and inventory parity fixtures. <!-- sdd-owner: implementation -->
- [ ] Add failing tests for token/generated parity, Light/Dark/`dusk` role completeness, WCAG/APCA state-matrix diagnostics, and dirty-baseline path exclusion. <!-- sdd-owner: implementation -->
- [ ] Implement `DreamcoderThemes/dreamcoder/targets.json`, `DreamcoderThemes/dreamcoder/targets.schema.json`, and `src/dreamcoder_theme/targets.py` with deterministic normalized plans and required/optional/excluded reasons. <!-- sdd-owner: implementation -->
- [ ] Implement parity and readability checks in `src/dreamcoder_theme/design_system.py`, `scripts/verify-theme-health.py`, and focused `tests/` fixtures without changing runtime activation. <!-- sdd-owner: implementation -->
- [ ] Verify parity across renderer exports, generation, installer, activation, health inventories and audit fixtures; exercise missing, duplicate, excluded, and `dusk` cases. <!-- sdd-owner: implementation -->
- [ ] Run focused pytest plus `python scripts/verify-theme-health.py`; record diagnostics with mode, role/state, metric, threshold, value, target, and source token. <!-- sdd-owner: implementation -->
- [ ] Remove duplicate inventory definitions only after parity tests pass; preserve stable ordering and the pre-existing dirty-worktree exclusion boundary. <!-- sdd-owner: implementation -->

### Deferred Parent Lifecycle Actions

- Select one of the proposed sub-400-line boundaries before relaunching apply.
- Preserve the pre-existing dirty baseline as excluded evidence; do not treat untracked design-system work as Slice 1 completion.

---

## Slice 1A — Manifest, Schema, Model, and Bounded Tests

### Status

- **state:** implementation complete; ready for parent lifecycle handling.
- **PR boundary:** Slice 1A only, stacked-to-main / auto-chain; 238 authored lines across the four Slice 1A files.
- **structured status consumed:** `applyState=ready`; `actionContext.mode=repo-local`; allowed edit root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- **action-context warning:** Pre-existing dirty paths were neither staged nor edited and are excluded from this evidence.

### Completed Tasks and Files

The four Slice 1A implementation-owned rows are visibly marked `[x]` in `tasks.md`.

- Added `DreamcoderThemes/dreamcoder/targets.json` and `targets.schema.json`.
- Added the consumer-neutral `src/dreamcoder_theme/targets.py` loader/model.
- Added `tests/test_targets.py` for schema, audit completeness, classifications, duplicates, and `dusk` rejection.

No renderer, installer, activation, health, palette, script, or Herdr runtime path was changed.

### Verification

- RED: `python -m pytest tests/test_targets.py -q` initially failed at collection because `dreamcoder_theme.targets` did not exist.
- GREEN/TRIANGULATE: `python -m pytest tests/test_targets.py -q` — 8 passed.
- `ruff check src/dreamcoder_theme/targets.py tests/test_targets.py` — passed.
- Direct Draft 2020-12 validation of `targets.json` against `targets.schema.json` — passed.
- `mypy` / `python -m mypy` — unavailable in this environment; no type-check result recorded.

### Deviation, Remaining Work, and Rollback

No design deviation. The next Slice 1B rows remain unchecked:

- [ ] Add failing focused tests in `tests/` for missing and extra renderer exports, generation outputs, installer modules, activation adapters, health entries, and duplicate output/selector ownership. <!-- sdd-owner: implementation -->
- [ ] Implement manifest-driven inventory discovery and parity adapters in `src/dreamcoder_theme/targets.py` or a narrowly scoped parity module, with integration points for `src/dreamcoder_theme/renderers.py`, `sync.py`, installer discovery, apply adapters, and `scripts/verify-theme-health.py` that report drift without changing runtime activation. <!-- sdd-owner: implementation -->
- [ ] Verify complete, missing, extra, and duplicate inventories using isolated fixtures; assert stable ordering and diagnostics naming the owning inventory and reconciliation action. <!-- sdd-owner: implementation -->
- [ ] Remove only proven duplicate inventory definitions and preserve compatibility with Slice 1A model APIs, historical evidence, and unrelated dirty-worktree paths. <!-- sdd-owner: implementation -->

Later slices remain unchecked in `tasks.md`. Roll back this slice by removing only `targets.json`, `targets.schema.json`, `targets.py`, and `test_targets.py`; preserve all pre-existing dirty worktree changes.

### Deferred Parent Lifecycle Actions

- Start or reuse bounded review for this Slice 1A scope only.
- Confirm the next stacked-to-main boundary before launching Slice 1B.

---

## Slice 1A Corrective Pass — Target Manifest Diagnostics

### Status and Boundary

- **state:** corrective implementation complete; return to parent lifecycle handling.
- **PR boundary:** Slice 1A only, stacked-to-main / auto-chain. No Slice 1B adapter or consumer integration was started.
- **structured status consumed:** authoritative OpenSpec `applyState=ready`, `nextRecommended=apply`; `actionContext.mode=repo-local`; workspace and allowed root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- **action-context warning:** The extensive pre-existing dirty worktree was preserved. No path was staged, reset, cleaned, committed, pushed, or edited outside the Slice 1A test and this cumulative progress artifact.

### Correction

- Added coverage proving `load_target_manifest()` converts both a missing manifest and malformed JSON into the documented `ManifestError`; the existing `_load_json()` exception boundary already implements this fail-closed behavior.
- The reported `dreamcoder_theme.targets` import is not reproducible with the repository test setup: `pyproject.toml` declares pytest `pythonpath = ["src"]`, and the focused test passes without a manual `PYTHONPATH` export. Basedpyright also discovers `src` as an extra path, so it resolves `dreamcoder_theme.targets`.
- The unresolved `jsonschema` source reported by Basedpyright when it auto-selects `.venv/bin/python` is an interpreter-environment mismatch: that environment lacks the dependency, while the repository test interpreter is `/usr/bin/python` with `jsonschema` installed. Re-running Basedpyright with that interpreter produces zero errors. No application import or source-root workaround was added.
- The path-traversal report is not applicable to the Slice 1A loader: it accepts an explicit `Path` capability from its programmatic caller and does not derive paths from request/user strings. The test writes only to pytest's `tmp_path` fixture. The production-assert report is likewise not applicable: assertions are pytest test assertions, not runtime validation. Neither finding was suppressed or weakened.

### Persisted Task State

- No checkbox changed: the four Slice 1A implementation rows were already visibly `[x]`, and this corrective coverage does not complete any Slice 1B row.
- All Slice 1B and parent-owned rows remain unchanged and deferred.

### Files Changed

- `tests/test_targets.py` — missing/malformed manifest regression coverage.
- `openspec/changes/repair-dreamcoder-theme-rollout/apply-progress.md` — this cumulative correction record.

### Verification

| Command                                                                                                                                         | Result                                                               |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| `python -m pytest tests/test_targets.py -q`                                                                                                     | PASS — 10 tests; source import resolves via repository pytest setup. |
| `ruff check src/dreamcoder_theme/targets.py tests/test_targets.py`                                                                              | PASS.                                                                |
| `basedpyright --project pyproject.toml --pythonpath "$(command -v python)" --level error tests/test_targets.py src/dreamcoder_theme/targets.py` | PASS — 0 errors, 0 warnings.                                         |

### TDD and Deviation

- Strict TDD is disabled in `openspec/config.yaml`; this standard-mode corrective test validates existing fail-closed behavior.
- No design deviation. The loader remains consumer-neutral and no runtime activation, renderer, installer, health, palette, schema, or manifest contract changed.

### Remaining Work

- Slice 1B remains the next implementation boundary; its exact unchecked implementation rows remain in `tasks.md` unchanged.
- Deferred lifecycle actions: parent-owned bounded review/receipt and stacked PR-boundary confirmation only.

---

## Slice 1A Corrective Pass — Scanner-Safe Exception and Fixture Handling

### Status and Boundary

- **state:** corrective implementation complete; return to parent lifecycle handling.
- **PR boundary:** Slice 1A only, stacked-to-main / auto-chain. No Slice 1B adapter or consumer integration was started.
- **structured status consumed:** authoritative OpenSpec `applyState=ready`, `nextRecommended=apply`; `actionContext.mode=repo-local`; workspace and allowed root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- **action-context warning:** The extensive pre-existing dirty worktree was preserved. No path was staged, reset, cleaned, committed, pushed, or edited outside the Slice 1A model, tests, and this cumulative progress artifact.

### Correction

- Replaced exception-driven schema validation with explicit schema checking plus `iter_errors()`, retaining target-specific validation diagnostics while removing the scanner-flagged exception form.
- Added narrow fixture-read and JSON-decoding failure handling in `tests/test_targets.py`; unreadable or malformed checked-in fixtures now fail the test explicitly instead of escaping from the fixture helper.
- The package import remains the normal `dreamcoder_theme.targets` import. Repository pytest configuration supplies `src`, and fresh Basedpyright diagnostics resolve it with zero errors; no source-path workaround or suppression was added.
- Path traversal is not applicable: the production API accepts a caller-provided `Path`, and tests write only within pytest `tmp_path`. Assertions remain pytest assertions, not production validation; neither finding was suppressed.

### Persisted Task State

- No checkbox changed: the four Slice 1A implementation rows remain visibly `[x]`; this narrowly scoped correction completes no Slice 1B work.
- Slice 1B remains unchecked, including:
  - [ ] Add failing focused tests in `tests/` for missing and extra renderer exports, generation outputs, installer modules, activation adapters, health entries, and duplicate output/selector ownership. <!-- sdd-owner: implementation -->
  - [ ] Implement manifest-driven inventory discovery and parity adapters in `src/dreamcoder_theme/targets.py` or a narrowly scoped parity module, with integration points for `src/dreamcoder_theme/renderers.py`, `sync.py`, installer discovery, apply adapters, and `scripts/verify-theme-health.py` that report drift without changing runtime activation. <!-- sdd-owner: implementation -->
  - [ ] Verify complete, missing, extra, and duplicate inventories using isolated fixtures; assert stable ordering and diagnostics naming the owning inventory and reconciliation action. <!-- sdd-owner: implementation -->
  - [ ] Remove only proven duplicate inventory definitions and preserve compatibility with Slice 1A model APIs, historical evidence, and unrelated dirty-worktree paths. <!-- sdd-owner: implementation -->

### Files Changed

- `src/dreamcoder_theme/targets.py`
- `tests/test_targets.py`
- `openspec/changes/repair-dreamcoder-theme-rollout/apply-progress.md`

### Verification

| Command                                                                                                                                                         | Result                                |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| `python -m pytest tests/test_targets.py -q`                                                                                                                     | PASS — 10 tests.                      |
| `ruff check src/dreamcoder_theme/targets.py tests/test_targets.py`                                                                                              | PASS.                                 |
| `ruff format --check src/dreamcoder_theme/targets.py tests/test_targets.py`                                                                                     | PASS — 2 files already formatted.     |
| `basedpyright --project pyproject.toml --pythonpath "$(command -v python)" --level error src/dreamcoder_theme/targets.py tests/test_targets.py`                 | PASS — 0 errors, 0 warnings, 0 notes. |
| `python -m compileall -q src/dreamcoder_theme/targets.py tests/test_targets.py` and `git diff --check -- src/dreamcoder_theme/targets.py tests/test_targets.py` | PASS.                                 |

### TDD and Deviation

- Strict TDD is disabled in `openspec/config.yaml`; this was a standard-mode corrective pass.
- No design deviation. Manifest contracts, runtime behavior, activation, ownership, and audited classifications are unchanged.
- Parent-owned lifecycle actions remain deferred: start/reuse bounded review and validate its receipt for this Slice 1A scope.

---

## Slice 1B — Inventory Parity Adapters: Scope Collision

### Status

- **state:** blocked before implementation.
- **PR boundary:** proposed feature-branch-chain work unit: Slice 1B only — manifest inventory parity adapters and their focused tests (no commit created).
- **structured status consumed:** authoritative OpenSpec `applyState=ready`, `nextRecommended=apply`; `actionContext.mode=repo-local`; allowed edit root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- **action-context warning:** The workspace contains extensive unrelated/pre-existing changes. The required Slice 1B consumer files are already modified and were not overwritten, staged, reset, cleaned, committed, pushed, or otherwise changed.

### Blocking Scope Collision

Slice 1B requires integration points in `src/dreamcoder_theme/renderers.py`, `src/dreamcoder_theme/sync.py`, installer discovery, apply adapters, and `scripts/verify-theme-health.py`. The current worktree reports pre-existing modifications for `renderers.py`, `sync.py`, `verify-theme-health.py`, and `scripts/apply-theme-mode.sh`; their contents already include concurrent rollout-related changes. Editing those paths would risk overwriting or claiming concurrent work, contrary to the declared dirty-worktree exclusion boundary.

No implementation task was completed, so `tasks.md` was intentionally left unchanged. The exact unchecked Slice 1B implementation rows remain:

- [ ] Add failing focused tests in `tests/` for missing and extra renderer exports, generation outputs, installer modules, activation adapters, health entries, and duplicate output/selector ownership. <!-- sdd-owner: implementation -->
- [ ] Implement manifest-driven inventory discovery and parity adapters in `src/dreamcoder_theme/targets.py` or a narrowly scoped parity module, with integration points for `src/dreamcoder_theme/renderers.py`, `sync.py`, installer discovery, apply adapters, and `scripts/verify-theme-health.py` that report drift without changing runtime activation. <!-- sdd-owner: implementation -->
- [ ] Verify complete, missing, extra, and duplicate inventories using isolated fixtures; assert stable ordering and diagnostics naming the owning inventory and reconciliation action. <!-- sdd-owner: implementation -->
- [ ] Remove only proven duplicate inventory definitions and preserve compatibility with Slice 1A model APIs, historical evidence, and unrelated dirty-worktree paths. <!-- sdd-owner: implementation -->

### Verification

| Command                                                                                                                                                                             | Result                                                                                              |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `git status --short -- src/dreamcoder_theme/renderers.py src/dreamcoder_theme/sync.py src/dreamcoder_theme/installer.py scripts/verify-theme-health.py scripts/apply-theme-mode.sh` | Confirmed pre-existing modifications in the required renderer, generation, health, and apply paths. |
| `python -m pytest tests/test_targets.py -q`                                                                                                                                         | PASS — 10 tests; only the completed Slice 1A manifest baseline was exercised.                       |

Strict TDD is disabled in `openspec/config.yaml`. No production or test source was changed, no task checkbox was marked, and no design deviation was made. Engram persistence was unavailable.
