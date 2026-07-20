# Implementation Tasks: Complete Dreamcoder Light/Dark Rollout

The former Ghostty-only plan is superseded. Its completed two-line parser remediation remains historical evidence and does not complete this rollout.

## Review Workload Forecast

| Field                   | Value                                                                                                                     |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Estimated changed lines | 3,000–4,200 total; 220–390 per implementation slice                                                                       |
| 400-line budget risk    | High                                                                                                                      |
| Chained PRs recommended | Yes                                                                                                                       |
| Suggested split         | PR 1: contract/palette → PR 2: generation → PR 3: ownership/apply → PR 4: Herdr gate/conditional support → PR 5: E2E/docs |
| Delivery strategy       | auto-chain                                                                                                                |
| Chain strategy          | stacked-to-main                                                                                                           |

Decision needed before apply: No
Chained PRs recommended: Yes
Chain strategy: stacked-to-main
400-line budget risk: High

Each slice below is independently reviewable, keeps tests with behavior, and must stop at its stated boundary. If a forecast exceeds 400 authored lines, split it before implementation.

## Historical Evidence (complete; not rollout completion)

- [x] Preserve the completed Ghostty 1.3.1-arch2 title-field remediation and its version-bound evidence; do not use it as proof of rendering, install, switching, reload, rollback, or include-graph coverage. <!-- sdd-owner: implementation -->

## Slice 1A — Manifest, Schema, Model, and Bounded Tests

**Dependency:** none. **Finish:** schema-valid manifest model and complete audited classification fixture; no consumer integration. **Estimated changed lines:** 250–350. **Rollback:** remove only `targets.json`, `targets.schema.json`, `src/dreamcoder_theme/targets.py`, and Slice 1A tests/fixtures; retain historical evidence and unrelated dirty worktree changes. <!-- sdd-owner: implementation -->

### RED

- [x] Add failing tests in `tests/` for manifest schema validity, required fields, classification reasons, duplicate IDs/output ownership/selector ownership, runtime `dusk` exclusion, and complete audited classification. <!-- sdd-owner: implementation -->

### GREEN

- [x] Implement `DreamcoderThemes/dreamcoder/targets.json`, `DreamcoderThemes/dreamcoder/targets.schema.json`, and `src/dreamcoder_theme/targets.py` with deterministic ordering, normalized target records, and required/optional/excluded contracts; do not modify activation or health consumers. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [x] Exercise valid, missing-field, duplicate, excluded, `dusk`, and incomplete-audit fixtures through the manifest loader and assert actionable target-specific diagnostics. <!-- sdd-owner: implementation -->

### REFACTOR

- [x] Keep the model API narrow and stable, remove only duplication inside Slice 1A files, and preserve the pre-existing dirty-worktree exclusion boundary. <!-- sdd-owner: implementation -->

## Slice 1B — Inventory Parity Adapters

**Dependency:** Slice 1A accepted. **Finish:** manifest parity checks for renderer, generation, installer, activation, and health inventories; no token/readability redesign. **Estimated changed lines:** 250–350. **Rollback:** revert only parity adapters and their focused tests; retain the Slice 1A manifest/model and historical evidence. <!-- sdd-owner: implementation -->

### RED

- [ ] Add failing focused tests in `tests/` for missing and extra renderer exports, generation outputs, installer modules, activation adapters, health entries, and duplicate output/selector ownership. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Implement manifest-driven inventory discovery and parity adapters in `src/dreamcoder_theme/targets.py` or a narrowly scoped parity module, with integration points for `src/dreamcoder_theme/renderers.py`, `sync.py`, installer discovery, apply adapters, and `scripts/verify-theme-health.py` that report drift without changing runtime activation. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Verify complete, missing, extra, and duplicate inventories using isolated fixtures; assert stable ordering and diagnostics naming the owning inventory and reconciliation action. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Remove only proven duplicate inventory definitions and preserve compatibility with Slice 1A model APIs, historical evidence, and unrelated dirty-worktree paths. <!-- sdd-owner: implementation -->

## Slice 1C — Token Parity and Readability Diagnostics

**Dependency:** Slice 1A accepted; Slice 1B parity API available; coordinate with `harden-theme-design-system`. **Finish:** canonical token/generated parity and generic WCAG/APCA state-matrix diagnostics, without Dark calibration or runtime activation changes. **Estimated changed lines:** 250–360. **Rollback:** revert only token/readability diagnostics and focused tests; retain manifest/parity foundation and historical evidence. <!-- sdd-owner: implementation -->

### RED

- [ ] Add failing tests for canonical `tokens.json`/`palette_tokens.py` parity, Light/Dark/`dusk` role completeness, WCAG/APCA state-matrix diagnostics, complete diagnostic context, and dirty-baseline path exclusion. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Implement token parity and generic readability checks in `src/dreamcoder_theme/design_system.py`, `scripts/verify-theme-health.py`, and focused `tests/` fixtures; keep `dusk` validation-only and do not alter runtime activation or Dark token values. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Exercise both readable and failing WCAG/APCA role/state cases and run focused pytest plus `python scripts/verify-theme-health.py`, recording mode, role/state, metric, threshold, value, target where material, and source token. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Centralize diagnostics only after parity and threshold tests pass, preserve independent WCAG blocking and APCA reporting, and keep pre-existing dirty-worktree paths excluded from evidence. <!-- sdd-owner: implementation -->

## Slice 2 — Nytherx Dark Calibration with Light Byte Baseline

**Dependency:** Slice 1C accepted. **Finish:** matrix-approved Dark role map and Dark artifacts; Light bytes unchanged. **Rollback:** revert only Dark calibration and generated Dark outputs.

### RED

- [ ] Add failing tests for a machine-readable Nytherx family/role map, restrained violet depth role, qualitative-only 80/15/5 metadata, accepted/rejected WCAG/APCA candidates, target-literal provenance, and content-addressed Light token/mapping/output baseline. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Implement the Dark role map and verified decision matrix beside the design-system contract; reject any candidate lacking complete downstream WCAG/APCA evidence. <!-- sdd-owner: implementation -->
- [ ] Calibrate only Dark canonical tokens in `themes/dreamcoder/tokens.json`, regenerate `src/dreamcoder_theme/palette_tokens.py` and declared Dark artifacts, and prohibit target-local palette literals. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Test every required body, heading, muted/comment, selection, focus, link, border, prompt, cursor/ANSI, and semantic state row with accepted and rejected candidates. <!-- sdd-owner: implementation -->
- [ ] Prove canonical Light JSON, role map, generated constants, and every tracked Light output are byte-identical before/after; run adaptive generation and prove tracked variants remain unchanged. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Centralize matrix diagnostics and literal scanning without weakening WCAG blocking behavior or turning 80/15/5 into a pixel-ratio gate. <!-- sdd-owner: implementation -->

## Slice 3 — Deterministic Terminal and Shell Generation

**Dependency:** Slices 1A–1C and 2 accepted. **Finish:** manifest-driven terminal/shell repository outputs. **Rollback:** revert only terminal/shell renderer migration and fixtures.

### RED

- [ ] Add failing deterministic two-run, newline/order, supported-field, canonical-role, and adaptive-contamination tests for Kitty, Ghostty, Warp, Tmux, Zellij, Starship, shell syntax, and `LS_COLORS`. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Migrate terminal/shell generation through `src/dreamcoder_theme/renderers.py`, leaf renderers, `sync.py`, and `writers.py`; replace or parity-guard manual Tmux/Kanagawa colors from canonical roles. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Generate Light and Dark twice in isolated repository fixtures, compare exact bytes and stable output ownership, and exercise Ghostty validation only within its recorded version boundary. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Remove redundant terminal inventories and preserve pure renderer contracts, LF endings, one trailing newline, and `write_if_changed` idempotency. <!-- sdd-owner: implementation -->

## Slice 4 — Editor, CLI, Desktop, and ML4W Output Parity

**Dependency:** Slices 1A–1C and 2 accepted. **Finish:** remaining manifest render contracts and overlay ordering. **Rollback:** revert only this renderer group.

### RED

- [ ] Add failing parity and deterministic tests for Neovim, Bat, Codex TextMate, Delta, fzf, OpenCode, Pi, Codex, Antigravity, Hyprland, Waybar, Rofi, Dunst, Btop, Firefox, Obsidian, and Cava as classified. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Migrate editor/CLI/desktop generation and ML4W color-only overlays through manifest plans, preserving ML4W layout, behavior, wallpaper, Matugen, and launch ownership. <!-- sdd-owner: implementation -->
- [ ] Add managed include ordering checks proving Dreamcoder overlays load after ML4W/Gentleman defaults without replacing structure. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Exercise both modes, unsupported optional availability, generated literal provenance, adaptive isolation, and exact second-run no-change behavior. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Consolidate renderer registration and output ownership only where parity tests prove no target drift. <!-- sdd-owner: implementation -->

## Slice 5 — ML4W/Gentleman Install and Ownership

**Dependency:** Slice 1B and applicable generation slices. **Finish:** safe fresh-install/repair plan. **Rollback:** revert planner changes; never restore external content.

### RED

- [ ] Add pytest and shell/Go fixture tests for missing, managed, managed-stale, partial-managed, external symlink/file/directory, missing-parent, and conflict destinations. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Implement the shared ownership classifier and normalized install plan in `src/dreamcoder_theme/installer.py`, installer modules, Stow planning, `scripts/dreamcoder-lib.sh`, and maintenance flows. <!-- sdd-owner: implementation -->
- [ ] Provision required artifacts only after validation; make conflicts fail closed, preserve user-owned bytes, and report optional absence with reason, impact, and corrective action. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Exercise fresh install, repair of missing/stale managed artifacts, external conflicts, missing parents, and repeated repair in isolated HOME/XDG fixtures. <!-- sdd-owner: implementation -->
- [ ] Verify ML4W/Gentleman ownership boundaries and exactly one idempotent managed color include. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Remove destructive generic backup/adoption paths unless covered by an explicit migration contract; keep rollback manifests path-bound. <!-- sdd-owner: implementation -->

## Slice 6 — Apply, Switching, Idempotency, and Rollback

**Dependency:** Slices 1, 3–5. **Finish:** common explicit/scheduled transactional boundary. **Rollback:** revert coordinator/adapters without reverting manifest or historical Ghostty work.

### RED

- [ ] Add failing tests for normalized outcomes, invalid mode rejection without mutation, explicit/scheduled equivalence, selector ordering, unchanged/no-reload runs, required failure, present-optional failure, reverse rollback, and rollback failure. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Implement the coordinator and target outcomes in a focused Python service plus adapters; update `scripts/apply-theme-mode.sh` and `scripts/theme-auto.sh` to consume one plan and report truthful aggregate status. <!-- sdd-owner: implementation -->
- [ ] Snapshot only proven managed content/selectors, apply selectors before selector-following writers, use atomic same-directory replacement, and rollback changed targets in reverse order. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Exercise Light→Dark and Dark→Light explicitly and on schedule, injected validation/write/reload failures, rollback restoration/revalidation, residual inconsistency, optional absence, and `dusk` non-mutation. <!-- sdd-owner: implementation -->
- [ ] Run pytest, bats/shell checks, and isolated runtime harness scenarios; prove no swallowed validator/reload errors and no second-run churn. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Remove shell target arrays and unconditional success paths while retaining structured per-target evidence and observable-limit statuses. <!-- sdd-owner: implementation -->

## Slice 7 — Ghostty Manifest Completion

**Dependency:** Slices 1, 3, and 6. **Finish:** broader Ghostty claims independently evidenced for the recorded version. **Rollback:** remove only new manifest coverage/tests.

### RED

- [ ] Add failing tests for version-bound parsed graph, Light/Dark rendering, ownership, validation, selector ordering, reload result, and forbidden `window-title`/`tab-title` restoration. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Add only independently proven Ghostty manifest/render/apply evidence; retain the historical parser fix as separate evidence and do not generalize it. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Run isolated version-appropriate validation and both switch directions; mark unsupported graph facts gated rather than guessing. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Keep Ghostty-specific behavior behind the manifest contract and remove no historical artifacts. <!-- sdd-owner: implementation -->

## Slice 8 — Herdr Contract and Evidence Harness (Mutation Forbidden Until Gate)

**Dependency:** Slice 1B; current 0.7.3 evidence is diagnosis only. **Finish:** supported profile or explicit `unsupported-contract`. **Rollback:** remove harness/profile code; external Herdr files must remain byte-identical.

### RED

- [ ] Add failing tests for exact executable/version/digest profile matching; supported/unsupported/unknown capabilities; schema and candidate validation; render evidence; parsed path; selector/content parity; semantic anchors; WCAG/APCA role/state matrix; reload/UI non-observability; and safe unsupported behavior. <!-- sdd-owner: implementation -->
- [ ] Add a Herdr evidence harness that verifies the reported illegibility/colors and reversed variants before any activation claim, using sanitized version-bound evidence and no visual assumption. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Implement `herdr_contract.py`, immutable profile/evidence records, and a read-only adapter that returns `skipped-not-installed` or non-success `unsupported-contract`; never mutate, rename, select, or reload external Herdr files while the gate is closed. <!-- sdd-owner: implementation -->
- [ ] Keep `renderers_herdr.py` unavailable and ensure generic sync/apply cannot advertise Herdr rendering, activation, readability, or reload. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Exercise absent, exact-version, changed-version, unknown capability, opposite-anchor, invalid matrix, missing validator, missing parsed-path proof, and synthetic complete-profile fixtures; production 0.7.3 remains disabled unless every gate passes. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Separate diagnosis, evidence, profile, and outcome rendering; document that process presence, filename identity, TOML syntax, or forced-zero reload does not prove support. <!-- sdd-owner: implementation -->

## Slice 9 — Herdr Renderer/Install/Activation (Conditional)

**Dependency:** Slice 8 complete supported profile and approved version-bound gate only. If gate remains closed, leave these tasks unchecked and record actionable exclusion; do not claim support.

### RED

- [ ] Add failing synthetic-profile tests for pure Light/Dark renderer output, schema validation, ownership classification, migration, atomic selector change, observable reload/restart, rollback, scheduled convergence, and Fish startup compatibility. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Implement `herdr_content`, repository-owned variants, managed-root provisioning, explicit migration only, and activation in separate bounded modules; never mutate unproven external paths. <!-- sdd-owner: implementation -->
- [ ] Update `scripts/herdr-theme-switch.sh` and common apply/scheduler integration only for profile-supported commands and evidence; preserve unsupported-contract behavior otherwise. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Verify the real installed profile—not only synthetic fixtures—with candidate/readability harness evidence before activation; exercise both modes, failures, rollback, scheduling, and Fish startup. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Remove duplicate Herdr paths and status handling only after ownership, selector/content identity, reload, and rollback evidence is complete. <!-- sdd-owner: implementation -->

## Slice 10 — End-to-End Verification and Operator Documentation

**Dependency:** all enabled slices. **Finish:** truthful completion report and recovery guidance. **Rollback:** revert only documentation/harness additions.

### RED

- [ ] Add failing end-to-end checks covering manifest completeness, all required renderers, Light/Dark generation, install/repair, both switch directions, schedule equivalence, idempotency, rollback, optional skips, `dusk` rejection, dirty-baseline exclusion, Ghostty boundary, and Herdr gated/supported outcome. <!-- sdd-owner: implementation -->

### GREEN

- [ ] Implement aggregate health summaries in `scripts/verify-theme-health.py`, doctor/maintenance reporting, and concise operator documentation for prerequisites, ownership conflicts, diagnostics, rollback, unsupported integrations, and evidence limits. <!-- sdd-owner: implementation -->

### TRIANGULATE

- [ ] Run `python -m pytest tests/ -v`, coverage threshold, `python scripts/verify-theme-health.py`, Ruff, mypy, ShellCheck, bats, and applicable Go tests/e2e in isolated fixtures; record exact results and runtime limitations. <!-- sdd-owner: implementation -->

### REFACTOR

- [ ] Remove duplicate docs/inventories and verify every acceptance claim is traceable to slice-owned paths, version-bound evidence, and the final manifest. <!-- sdd-owner: implementation -->

## Parent Lifecycle Actions

- [ ] Start or reuse one bounded review for the current implementation scope and validate its receipt before delivery; do not create review work for historical or gated paths. <!-- sdd-owner: parent -->
- [ ] Confirm the selected stacked-to-main PR boundary, apply only the next dependency-ready slice, and keep Herdr mutation blocked until its version-bound gate passes. <!-- sdd-owner: parent -->
- [ ] After implementation and verification, confirm all required targets are classified, all unchecked conditional Herdr tasks are truthfully reported, and pre-existing dirty-worktree changes remain excluded. <!-- sdd-owner: parent -->
