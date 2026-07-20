# Tasks: Repair Global Gentle AI and Deliver Theme Phase 1

## Review Workload Forecast

| Field                   | Value                                                                                                                                |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Estimated changed lines | Repository-only nine-path unit: approximately 250–450 authored lines; global remediation is external and not part of repository diff |
| 400-line budget risk    | High                                                                                                                                 |
| Chained PRs recommended | Yes                                                                                                                                  |
| Suggested split         | PR 1: nine-path validation/evidence; PR 2: bounded corrections or remaining delivery work                                            |
| Delivery strategy       | ask-on-risk                                                                                                                          |
| Chain strategy          | pending                                                                                                                              |

Decision needed before apply: Yes
Chained PRs recommended: Yes
Chain strategy: pending
400-line budget risk: High

## Execution invariants

- [x] Read `openspec/changes/repair-gga-and-theme-delivery/design.md`, `proposal.md`, `specs/global-gentle-ai/spec.md`, and `specs/dreamcoder-phase1/spec.md`; record their artifact identities in the run manifest before any stage. <!-- sdd-owner: implementation -->
- [x] Create a private `0700` evidence root at `${XDG_STATE_HOME:-$HOME/.local/state}/gentle-ai-remediation/<UTC_RUN_ID>/`, outside the repository and managed roots, with append-only records, redacted blobs, receipts, manifests, and a final seal. <!-- sdd-owner: implementation -->
- [x] Use sanitized allowlisted environments, `LC_ALL=C`, `/dev/null` stdin, fixed timeouts, private temporary XDG paths, and no complete `env`, credential, provider, shell-startup, or unrelated-user-data capture. <!-- sdd-owner: implementation -->
- [ ] Treat each stage as a sealed work unit; permit the next stage only after a passed receipt, proven ownership, recorded rollback, and all postconditions. <!-- sdd-owner: implementation -->
- [x] On any stop condition, stop mutation, capture read-only post-state, seal `blocked` or `failed-partial`, and do not repair forward. <!-- sdd-owner: implementation -->

## S0 — Read-only global baseline and provenance freeze

**Allowed targets:** read-only discovery of Gentle AI, Engram, GGA, Pi, OpenCode, 11 doctor agents, managed roots/assets, hooks/consumers, package metadata, official probes, repository status, and native review status. No mutation, staging, reset, clean, stash, checkout, hook/review-authority operation.

- [x] Resolve and record Gentle AI authority commit `9c7bac8129e7936f414b25830ef591e173ed48ed`; resolve GGA `v2.10.1` with `git ls-remote --tags https://github.com/Gentleman-Programming/gentleman-guardian-angel.git 'refs/tags/v2.10.1' 'refs/tags/v2.10.1^{}'`, accepting exactly one full 40-lowercase-hex commit. <!-- sdd-owner: implementation -->
- [x] Independently receipt `command -v`, `type -a`, version/help/doctor probes for `gentle-ai`, `engram`, `gga`, `pi`, and `opencode`; canonicalize each candidate with `readlink`, `stat`, and `sha256sum` without invoking malformed GGA. <!-- sdd-owner: implementation -->
- [ ] Run `bash -n <resolved-gga-entrypoint>` before any GGA version/help probe; record declared `providers.sh`, `cache.sh`, and `pr_mode.sh` only after confirming names from installed entrypoint and pinned official source. <!-- sdd-owner: implementation -->
- [ ] Query only applicable read-only ownership adapters (Homebrew, Debian, RPM, Arch, npm-family, and Gentle AI metadata); classify unsupported/conflicting ownership as `unknown`. <!-- sdd-owner: implementation -->
- [x] Fetch and verify the pinned Gentle AI authority in an isolated probe using `git init`, `git fetch --depth 1`, `rev-parse --verify FETCH_HEAD`, and detached checkout; never execute fetched repository code. <!-- sdd-owner: implementation -->
- [ ] Build the complete expected/installed union matrix for assets, templates, skills, configuration fragments, generated metadata, manifests, checksums, directories, symlinks, and binaries; include one sorted row per item with source blob, pinned URL, owner, hashes, comparison rule, and status. <!-- sdd-owner: implementation -->
- [ ] Capture stable IDs for managed binaries, roots, hooks/consumers, native authority, and exactly 11 doctor-reported agents; preserve repository `git status --porcelain=v2 -z` and native status as observations only. <!-- sdd-owner: implementation -->
- [x] Seal S0 only if no unexpected extra, ownership conflict, unknown expectation, ambiguous transform, incomplete checksum, missing rollback route, or unresolved GGA commit exists; otherwise stop and escalate with record IDs. <!-- sdd-owner: implementation -->

## S1 — Preferred official managed binary refresh

**Preferred allowed mutation:** exactly `gentle-ai upgrade`; only proven Gentle AI-owned binary roots. **Forbidden:** binary copy, PATH/startup edits, hooks, repository paths, native review state, GGA checkout use, upstream installers, or manual fallback.

- [ ] Confirm sealed S0, unchanged `gentle-ai` realpath/hash, known mutation roots, scope-safe official rollback/downgrade route, and resolved GGA commit before invoking the preferred route. <!-- sdd-owner: implementation -->
- [ ] Record pre-operation target snapshots, package identities, no-change sentinels, rollback command, and approved target boundary. <!-- sdd-owner: implementation -->
- [ ] Execute only `gentle-ai upgrade` and receipt argv, executable identity, sanitized environment, output, exit, and target diff. <!-- sdd-owner: implementation -->
- [ ] Re-inventory managed binaries; rerun doctor; syntax-check GGA; verify entrypoint/libraries share compatible official ownership; run isolated documented GGA version/help probes only after syntax and provenance pass. <!-- sdd-owner: implementation -->
- [ ] Accept S1 only when expected versions/probes pass and hooks, shell startup, repository, and native-authority sentinels are byte-identical; on failure mark partial, use only recorded rollback after authorization, then require a fresh baseline. <!-- sdd-owner: implementation -->

### Conditional GGA-R0 recovery branch

**Dependency:** this branch is same-run S0 evidence only and is mutually exclusive with a valid-probe upgrade branch. It does not authorize execution during planning.

- [x] In the same sealed S0 run, preserve a separate invalid-GGA probe record proving syntax failure, unusable version invocation, or required-library resolution failure; do not source or invoke the malformed entrypoint. <!-- sdd-owner: implementation -->
- [x] In that same run, resolve the pinned official read-only upgrade-checker contract and execute its exact documented checker argv (use `gentle-ai update` only when the pinned authority proves that exact form), recording a distinct `gga-version-unknown` or `gga-health-unestablished` result. <!-- sdd-owner: implementation -->
- [x] Seal a derived GGA-R0 decision requiring `invalid_probe AND checker_unknown_or_unhealthy AND same_run AND unchanged_sentinels`; block on missing, ambiguous, conflicting, cross-run, mutating, or health-establishing checker evidence. <!-- sdd-owner: implementation -->
- [ ] Before any component dry-run, prove the pinned authority documents `gentle-ai install --component gga --dry-run`, run it once with the resolved executable/environment, and retain its complete machine-readable plan; do not guess flags, add privilege, pipe output, or substitute an installer. <!-- sdd-owner: implementation -->
- [ ] Parse the dry-run into `records/gga-recovery-targets.json`, one row per create/replace/relink/chmod/rename/remove operation, including exact path, component, operation, expected owner, mode, source artifact/version/commit, and target-set digest; block incomplete paths, globs, unknown operations, source mismatch, or plan drift. <!-- sdd-owner: implementation -->
- [ ] For every extracted target, prove installer ownership and official provenance from pinned manifests/package metadata; reject overlaps with hooks, startup files, repository paths, native authority, unrelated roots, or the v2.6.1 checkout. <!-- sdd-owner: implementation -->
- [ ] Capture exact pre-target snapshots and hashes/package identities for every dry-run target, plus a private backup manifest outside managed roots; verify backup completeness and record must-not-change sentinels immediately before and after the dry-run. <!-- sdd-owner: implementation -->
- [ ] Record an owner-supported rollback for every target and every previewed failure mode, including command argv, restored artifact identity, scope, preconditions, and partial-install recovery; reject ad hoc `cp`, `mv`, symlink creation, archive extraction, package-database edits, or unsupported downgrade. <!-- sdd-owner: implementation -->
- [ ] Seal GGA-R0 eligibility, dry-run digest, target-set digest, ownership/provenance rows, snapshot/backup digest, rollback digest, and the single approved command `gentle-ai install --component gga`; do not run it if any prerequisite is unknown. <!-- sdd-owner: implementation -->
- [ ] After explicit recovery authorization, execute `gentle-ai install --component gga` at most once with no extra flags, privilege escalation, alternate HOME, channel override, component/agent additions, or environment/path changes; stop if confirmation, target set, source, or scope differs from the sealed plan. <!-- sdd-owner: implementation -->
- [ ] Validate changed paths equal the sealed GGA-only target set; rerun `bash -n`, official library ownership/provenance, expected version, documented isolated version/help probes, doctor, and all protected sentinels in the required order. <!-- sdd-owner: implementation -->
- [ ] On nonzero exit, partial application, validation failure, or sentinel drift, seal `failed-partial`, do not retry/sync/upgrade or use manual fallback, invoke only the preapproved rollback after recovery authorization, verify restoration, and start a fresh S0 run before the preferred upgrade branch. <!-- sdd-owner: implementation -->
- [ ] Treat successful component recovery as provisional: it does not replace the preferred `gentle-ai upgrade`; only a fresh passed S0 may authorize continuation to the preferred upgrade route. <!-- sdd-owner: implementation -->

## S2 — Official managed asset synchronization

**Allowed mutation:** exactly `gentle-ai sync`; only proven sync-owned asset roots. **Invariant:** asset synchronization does not constitute binary repair.

- [ ] Confirm S1 passed (or independently proven healthy), sealed complete matrix, only explainable `sync-required` rows, asset rollback, and unchanged binary sentinels. <!-- sdd-owner: implementation -->
- [ ] Execute only `gentle-ai sync`, explicitly receipt that it is asset-only, and capture pre/post manifests and target ownership. <!-- sdd-owner: implementation -->
- [ ] Rebuild the entire matrix from the same pinned authority and boundaries; require unchanged expected-inventory digest and map every changed row to an S0 row plus the sync receipt. <!-- sdd-owner: implementation -->
- [ ] Verify exact bytes/rendered outputs, modes, owners, symlinks, manifests, checksum coverage, generated metadata, and directory contracts; accept only `exact-match` or declared variants. <!-- sdd-owner: implementation -->
- [ ] Stop on any unexplained path, binary change, unknown, conflict, parse failure, or checksum gap; seal partial state and follow official restoration/escalation without a second sync attempt. <!-- sdd-owner: implementation -->

## S3 — Conditional Pi repair

**Allowed mutation if required:** exactly `gentle-ai install --agent pi`; otherwise record `skipped-healthy`. **Forbidden:** direct npm/pnpm/bun/Homebrew/system-package install or file copy.

- [ ] Decide `skipped-healthy` only from one canonical executable, supported probe, healthy doctor, known package source, package ownership, and integrity evidence; otherwise prove manager/source, help route, package identity, and rollback before mutation. <!-- sdd-owner: implementation -->
- [ ] If repair is required, execute exactly `gentle-ai install --agent pi` and receipt package root, owner, pre/post identity, exit, and scope. <!-- sdd-owner: implementation -->
- [ ] Re-resolve Pi, verify package database/source/version/hash/integrity, run documented isolated version/help, rerun doctor, and compare all sentinels. <!-- sdd-owner: implementation -->
- [ ] Stop and rollback only through the recorded supported route if delegation, root, candidates, or health differs; require fresh baseline before continuation. <!-- sdd-owner: implementation -->

## S4 — OpenCode ownership and duplicate resolution

**Allowed mutation:** one separately approved, owner-authorized unlink/uninstall/relink/configuration command with documented rollback. **Forbidden:** direct PATH rewrite, shell-startup edit, blind deletion/symlink creation, hook mutation, repository/native-review mutation.

- [ ] Enumerate exact `opencode` candidates across captured PATH entries, retaining duplicate PATH directories, realpaths, inodes, hashes, owners, and precedence. <!-- sdd-owner: implementation -->
- [ ] Classify alias duplicates versus distinct installations and prove exactly one owner for every candidate through Gentle AI, Homebrew, OS package, npm-family, official installer receipt, or documented user ownership. <!-- sdd-owner: implementation -->
- [ ] Record canonical candidate, owner documentation/version, target preview, exact command, affected paths, and exact restoration command; block if ownership, rollback, or safe command is ambiguous. <!-- sdd-owner: implementation -->
- [ ] After separate approval, execute the one owner command once; re-enumerate candidates and doctor, requiring no duplicate warning and unchanged hooks/startup/repository/native sentinels. <!-- sdd-owner: implementation -->
- [ ] On regression use only the recorded owner rollback; if warning remains or rollback fails, seal and escalate without waiver. <!-- sdd-owner: implementation -->

## S5 — Reconcile all 11 doctor agents

- [ ] Parse sealed baseline doctor output with a versioned parser and require cardinality exactly 11; block ambiguity rather than dropping records. <!-- sdd-owner: implementation -->
- [ ] Re-run and parse doctor identically; join by stable ID and classify each as unchanged, authorized-change, missing, new, or ambiguous. <!-- sdd-owner: implementation -->
- [ ] For every agent record executable/package candidates, canonical path, supported documented probe, owner, provenance, version, health, and official repair route; require changes to map to exactly one S1–S4 receipt. <!-- sdd-owner: implementation -->
- [ ] Seal the sorted 11-row matrix only with zero unknown, ambiguous, failed supported probes, ownership conflicts, unexplained failures, and duplicate OpenCode warnings; newly needed repair becomes a new scoped unit. <!-- sdd-owner: implementation -->

## S6 — Isolated Dreamcoder nine-path validation

**Exactly allowed paths:** `.github/workflows/theme-validation.yml`, `DreamcoderThemes/dreamcoder/tokens.json`, `DreamcoderThemes/dreamcoder/tokens.schema.json`, `docs/DREAMCODER_DESIGN_SYSTEM.md`, `scripts/apply-theme-mode.sh`, `scripts/verify-theme-health.py`, `src/dreamcoder_theme/palette_tokens.py`, `tests/test_token_parity.py`, `tests/test_theme_health.py`. No other repository path may be read as candidate input, staged, mutated, or delivered.

- [ ] Capture real index checksum, repository status digest, HEAD identities, and nine-path pre-work blob/mode identities without staging, reset, clean, stash, checkout, or reclassification. <!-- sdd-owner: implementation -->
- [ ] Build the synthetic candidate with temporary `GIT_INDEX_FILE`, object directory, alternate objects, `git read-tree HEAD`, exact nine-path `git add`, `write-tree`, `diff-tree`, and archive extraction; verify all temporary paths remain under private probe root. <!-- sdd-owner: implementation -->
- [ ] Require `diff-tree` set equality with exactly the nine manifest paths and expected file types; block missing, extra, renamed, or type-changed paths. <!-- sdd-owner: implementation -->
- [ ] In the candidate tree, derive supported commands from checked-in configuration and run separate JSON/schema validation, `python scripts/verify-theme-health.py`, generated/static parity, `tests/test_token_parity.py`, and `tests/test_theme_health.py` records with exact interpreter/version and scope manifests. <!-- sdd-owner: implementation -->
- [ ] Run shell syntax validation for `scripts/apply-theme-mode.sh` and its documented isolated temporary-target scenario; record `N/A` with exact safety reason when no safe temporary runtime exists. <!-- sdd-owner: implementation -->
- [ ] Validate workflow syntax using the documented local validator when available; treat absent validator as explicit blocker or documented CI dependency, never a fabricated pass. <!-- sdd-owner: implementation -->
- [ ] Require every command exit 0, no undeclared writes, unchanged real index/status/hook/object state, and evidence bound to candidate tree and nine blob IDs; seal Phase 1 manifest and receipt. <!-- sdd-owner: implementation -->
- [ ] Roll back only the nine intended paths from captured identities or owner-reviewed inverse patch; stop if pre-existing intended content cannot be separated, and never use repository-wide reset/checkout/clean/stash. <!-- sdd-owner: implementation -->

## S7 — Parent-owned native review and delivery gate

- [ ] Parent records locked native authority and stops; do not start/finalize/reconcile/delete/invalidate review lineages until the parent restores eligibility through the native process. <!-- sdd-owner: parent -->
- [ ] After eligibility, parent starts or reuses native bounded review for the exact S6 candidate and nine paths only; any correction remains inside those paths and creates fresh candidate evidence. <!-- sdd-owner: parent -->
- [ ] Before commit, parent stages exactly the nine reviewed paths without content/mode drift and runs `gentle-ai review validate --gate pre-commit --cwd <repo>`; before push/PR, validate the corresponding native gate. <!-- sdd-owner: parent -->
- [ ] Parent blocks commit, push, PR, or terminal mirror reconciliation on missing, scope-changed, invalidated, escalated, or lock-blocked authority. <!-- sdd-owner: parent -->

## Cross-stage acceptance and recovery

- [ ] Validate evidence hash chain, redactions, blob digests, stage receipts, domain separation, provenance URLs/commits, target ownership, and final seal; reject changed digests or missing records. <!-- sdd-owner: implementation -->
- [ ] Confirm global evidence never enters repository delivery and no repository path enters global mutation receipts; confirm all prohibited sentinels remain unchanged. <!-- sdd-owner: implementation -->
- [ ] For any failure: stop, capture read-only state, seal stage, obtain explicit recovery authorization, execute only recorded owner rollback, prove restoration in a fresh baseline, and escalate when rollback is unavailable or fails. <!-- sdd-owner: implementation -->
