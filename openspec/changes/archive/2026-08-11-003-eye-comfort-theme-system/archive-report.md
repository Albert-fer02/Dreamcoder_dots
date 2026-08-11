# Archive Report: eye-comfort-theme-system

**Archived**: 2026-08-11
**Status**: PASS (full change delivered and verified)
**Store**: openspec
**Change ID**: SDD 1 of the chained Dreamcoder OS theme series

## Outcome

The eye-comfort theme system is **fully delivered**: 6/6 PR slices committed to `main`,
all 47 implementation-owned tasks checked, final gate green, and the Night/Dim profile
verified live on the user's system. This archive closes the change.

Per the authoritative archive final-state handoff, the on-disk `verify-report.md` is the
**PR 1 slice snapshot only** (written 2026-08-10 after PR 1); the full-change final state
recorded in this report outranks that intermediate snapshot.

## Final State (archive-time handoff facts)

- **6/6 PR slices committed on `main`, in order**:
  - `4438cd2` — PR1: canonical APCA core + dual WCAG+APCA gate
  - `235cb4a` — PR2: Night transform + token corrections
  - `2a872e5` — PR3: 32-target coverage + 30 Night artifacts
  - `3a4bb46` — PR4: `render_profile` settings + profile-aware selectors
  - `ec874be` — PR5: CLI `theme apply` + transactional rollback
  - `e2bc448` — PR6: blocking health + docs + CI + wrapper fix
- **PR 1 native review**: lineage `review-9f83a57dfd0396ba`, 4 lenses, 1 CRITICAL
  corrected within budget (APCA gate gap — both metrics now required on every declared
  pair), **APPROVED**; pre-commit gate `allow`.
- **Final gate (post-PR6)**: 470 tests passed (+31 subtests), ruff clean, mypy clean
  (50 files), bats 23/23, `verify-theme-health.py` exit 0 (4 candidates
  Light/Dark/Dusk/Night + 32-consumer coverage), generated-artifact drift clean.
- **CLI verified live**: `dreamcoder night` and `dreamcoder light` both exit 0 with
  32/32 coverage (user tested on the real system; a Hyprland session restart was needed
  to pick up new colors — transient apply state, resolved).
- **Delivery note**: review mode is OFF clone-local (pre-existing corrupted authority in
  the store — 14/16 lineages malformed; harness-bundled native 2.2.2 cannot derive
  unique receipts). PR2–PR6 were delivered under ordinary repository policy per the
  user's explicit decision.

## Artifacts Read

- `openspec/changes/eye-comfort-theme-system/proposal.md`
- `openspec/changes/eye-comfort-theme-system/specs/eye-comfort/spec.md`
- `openspec/changes/eye-comfort-theme-system/design.md` (incl. ADR-001…ADR-004)
- `openspec/changes/eye-comfort-theme-system/tasks.md` (49 rows; 47 implementation checked)
- `openspec/changes/eye-comfort-theme-system/apply-progress.md` (Batches 1–6)
- `openspec/changes/eye-comfort-theme-system/verify-report.md` (PR 1 slice snapshot)
- `openspec/config.yaml` (`rules.archive`: warn before destructive deltas — N/A here)
- Native status: `gentle-ai sdd-status eye-comfort-theme-system --json --instructions`
- Repository archive convention: `openspec/changes/archive/2026-07-02-002-refactor-renderer-pipeline/`

## Per-Phase Status

| Phase | Scope | PR | Status |
| --- | --- | --- | --- |
| 0 | Preparation audit (32-consumer mapping, guardrail audit, debt register) | PR1 | Done (`4438cd2`) |
| 1 | Canonical APCA core + dual gate (R1, R2, R9) | PR1 | Done, native-review approved (`4438cd2`) |
| 2 | Night transform + 4-candidate validation + token corrections (R3, R4) | PR2 | Done (`235cb4a`) |
| 3 | 32-target coverage + Night repo generation (R5) | PR3 | Done (`2a872e5`) |
| 4 | Settings + profile-aware selectors (R6) | PR4 | Done (`3a4bb46`) |
| 5 | CLI activation + transaction/rollback (R7) | PR5 | Done (`ec874be`) |
| 6 | Blocking health + docs + CI (R8, R10) | PR6 | Done (`e2bc448`) |

All 10 requirements (R1–R10) implemented; PR1 verification PASS covers R1, R2, R9;
remaining phases verified by the final gate evidence above (470 tests, health exit 0,
live CLI).

## Canonical Spec Sync (archive-time, per repo convention)

- **Domains synced**: `eye-comfort`
- **Sync type**: **ADDED (new canonical domain)** — no `openspec/specs/eye-comfort/spec.md`
  existed; change spec treated as the full domain spec and copied to the canonical path.
- **Sync mode**: archive-time sync fallback performed per the parent's instruction to
  move the change "per the repo convention" (the established convention, evidenced by
  the previous archive's `Main Specs Updated` / `Main Spec Locations`). No
  `sync-report.md` existed for this change. The sync is **additive-only**: zero
  MODIFIED/REMOVED requirement blocks, zero destructive delta, so no destructive-merge
  warning or approval was required (`rules.archive` satisfied trivially).
- **Canonical target**: `openspec/specs/eye-comfort/spec.md`

### ADDED Requirement Names (10)

1. Canonical APCA contrast implementation
2. Independent blocking WCAG and APCA dual gate
3. Deterministic Night/Dim palette transformation
4. Pre-write validation and fail-closed write behavior
5. All-active-target Night coverage
6. Persistent render profile setting
7. Dreamcoder CLI activation and profile exit
8. Blocking health verification
9. Focused regression coverage for the eye-comfort contract
10. Evidence and claims boundaries

### MODIFIED / REMOVED

None. No other active change touches the `eye-comfort` domain (native status
`relationships.sameDomainActiveChanges: []`; directory scan confirmed).

## Task Completion State

- **Implementation-owned tasks**: 47/47 checked `[x]` — **no `- [ ]` implementation task
  box remains** (verified by re-reading `tasks.md` at archive time).
- **Parent-owned lifecycle rows (2, `sdd-owner: parent`), reconciled** — left unchecked in
  `tasks.md` as recorded audit state (no mechanical checkbox repair was instructed):
  - *"Start or reuse the bounded implementation review per PR slice (1–6)…"* →
    **Reconciled**: PR1 full native review (lineage `review-9f83a57dfd0396ba`, 4 lenses,
    1 CRITICAL corrected, APPROVED); PR2–PR6 delivered under ordinary repository policy
    per the user's explicit decision (delivery note above).
  - *"Validate the content-bound review receipt at pre-commit/pre-push/pre-PR gates…"* →
    **Reconciled**: PR1 pre-commit gate `allow`; PR2–PR6 review gate structurally absent
    (review mode off clone-local, corrupted authority) — delivery under ordinary
    repository policy per the user's explicit decision.

## Verification Evidence

- **PR 1 slice** (on-disk `verify-report.md`): PASS for R1/R2/R9; 371 passed +31
  subtests at that time; ruff/mypy clean; health exit 0 (advisory path, byte-identical
  to baseline); no activation wiring present (correctly deferred).
- **Final state** (archive-time handoff, outranks the PR1 snapshot): 470 tests passed
  (+31 subtests), ruff clean, mypy clean (50 files), bats 23/23,
  `verify-theme-health.py` exit 0 (Light/Dark/Dusk/Night + 32-consumer coverage),
  generated-artifact drift clean; live `dreamcoder night` / `dreamcoder light` exit 0
  with 32/32 coverage.

## Structured Status and actionContext Findings

- Native `gentle-ai sdd-status` (authoritative, `artifactStore: openspec`):
  `artifactPaths` all present; `taskProgress` 47/49 (2 parent-owned rows pending);
  `dependencies.proposal/specs/design/tasks: all_done`, `apply: ready`;
  `blockedReasons: []`; `remediationState.required: false`; `nextRecommended: apply`
  (engine-side view of the 2 unchecked parent rows — reconciled here per the parent
  handoff and the status contract's deferred-parent-actions rule).
- `actionContext`: `mode: repo-local`, `workspaceRoot` = repo, `allowedEditRoots: [repo]`
  — all archive operations (sync copy, report write, move) are inside the authoritative
  workspace; no edit-root blocker.

## Destructive Merge

None performed. The canonical sync was a pure additive copy (new domain). No approval
required and no blocker raised.

## Archived Path

`openspec/changes/archive/2026-08-11-003-eye-comfort-theme-system/`
(convention: `<ISO-date>-<NNN>-<change-name>`, continuing the sequence after
`2026-07-02-002-refactor-renderer-pipeline`).

## Follow-Ups (deferred, NOT part of this change)

- **SDD 2** — hexagonal architecture: renderer ports, declarative sync registry,
  installer naming unification.
- **SDD 3** — governance: visual-regression baselines, docs drift.
- **ML4W 2.14.1 upgrade evaluation** — user on 2.13; 2.14 moved to Quickshell status bar
  default (fixes the waybar taskbar issue).
- **Pre-existing tooling debt** — shellcheck SC1091; pinned ruff v0.7.0 UP038.

## Audit Trail

- Proposal → Spec → Design → Tasks → Apply (6 batches) → Verify (PR1) → Archive ✅
- 47/47 implementation tasks complete; 2 parent-owned rows reconciled per handoff.
- No staged files at archive time; archive moved via filesystem, history preserved by git.
- Memory observation IDs: N/A (openspec mode; no Engram save performed).
