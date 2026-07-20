# Apply Progress: Repair GGA and Theme Delivery

## S0 / PR boundary

- **Delivery:** `auto-chain` / `feature-branch-chain`; assigned boundary was **S0 read-only global baseline and provenance freeze only**.
- **Outcome:** `blocked`. No later-stage lifecycle operation, repository implementation, staging, commit, hook, PATH, shell, binary, global-config, or review-authority mutation was performed.
- **Rollback:** N/A — this slice did not mutate targets.

## Structured status consumed

```yaml
changeName: repair-gga-and-theme-delivery
artifactStore: openspec
applyState: ready
dependencies: { apply: ready, verify: blocked, archive: blocked }
actionContext:
  mode: repo-local
  workspaceRoot: /home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots
  allowedEditRoots: [/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots]
warnings: []
nextRecommended: apply
```

## Completed implementation tasks and checkbox updates

- `[x]` Read planning artifacts; SHA-256 identities are in the external run manifest.
- `[x]` Created and sealed private `0700` evidence root with records, redacted blobs, manifests, receipt, and seal.
- `[x]` Used an allowlisted `LC_ALL=C` environment, `/dev/null` stdin, timeouts, and private XDG probe paths; no complete environment/configuration dump was captured.
- `[x]` Resolved official GGA `v2.10.1` to `1124c3672f082c56b033c4e23a30e95d0e8cd593`.
- `[x]` Fetched, verified, and detached the Gentle AI authority at `9c7bac8129e7936f414b25830ef591e173ed48ed` without executing fetched code.
- `[x]` Stopped on syntax failure, captured remaining read-only observations, sealed `blocked`, and did not repair forward.
- `[x]` Applied the S0 seal-or-escalate policy; escalation names record `000022` and the incomplete-matrix boundary.

## Evidence and command outcomes

- Root: `/home/dreamcoder08/.local/state/gentle-ai-remediation/20260716T193922Z-s0-3833df2a/` (private/sealed; no secrets exposed).
- `run.json`, `receipts/S0.json`, `seal.json`, and records `000001`–`000024` are the reproducible evidence set.
- Official GGA tag lookup: exit 0 (`000001`); authority init/fetch/verify/detach/HEAD: exit 0 (`000002`–`000007`).
- Command discovery, manager/Engram probes, repository status observation, and native read-only review status: independently receipted (`000008`–`000024`).
- Shell syntax validation of the resolved GGA entrypoint: **exit 2** (`000022`). GGA was not invoked; libraries were neither sourced nor accepted.

## Stop conditions and escalation

1. **GGA syntax failure:** `000022` blocks all GGA invocation and later lifecycle stages.
2. **Incomplete S0 matrix:** deterministic expected/installed conformance, ownership, and rollback evidence were not produced before the stop. `receipts/S0.json` is `blocked` with `next_stage_permitted: false`.
3. **Receipt-integrity warning:** the sealed S0 receipt omits `000022` from `stop_reason`. It was intentionally not edited after sealing. A fresh authorized baseline must produce a complete receipt.

**Affected boundary:** managed GGA and all unproven managed roots.  
**Safe alternative:** authorize a fresh complete read-only S0 matrix/ownership/rollback audit (safe), then seek a separately authorized official lifecycle operation only if ownership and rollback are proven (mutating). Manual replacement remains prohibited.  
**Smallest additional scope:** a fresh read-only S0 audit and complete sealed receipt; no mutation approval requested.

## Changes

- `openspec/changes/repair-gga-and-theme-delivery/tasks.md` — seven completed implementation checkboxes.
- `openspec/changes/repair-gga-and-theme-delivery/apply-progress.md` — this report.
- External private evidence root above. No other repository or machine target changed.

## Verification

- Test suite: N/A — this is discovery-only and stopped before repository validation.
- Runtime harness: N/A — executing malformed GGA is prohibited.

## Deviations

No target-scope deviation. S0 could not complete because the GGA syntax probe failed and required matrix/ownership/rollback proof is incomplete.

## Remaining implementation tasks (exact persisted unchecked lines)

- [ ] Treat each stage as a sealed work unit; permit the next stage only after a passed receipt, proven ownership, recorded rollback, and all postconditions. <!-- sdd-owner: implementation -->
- [ ] Independently receipt `command -v`, `type -a`, version/help/doctor probes for `gentle-ai`, `engram`, `gga`, `pi`, and `opencode`; canonicalize each candidate with `readlink`, `stat`, and `sha256sum` without invoking malformed GGA. <!-- sdd-owner: implementation -->
- [ ] Run `bash -n <resolved-gga-entrypoint>` before any GGA version/help probe; record declared `providers.sh`, `cache.sh`, and `pr_mode.sh` only after confirming names from installed entrypoint and pinned official source. <!-- sdd-owner: implementation -->
- [ ] Query only applicable read-only ownership adapters (Homebrew, Debian, RPM, Arch, npm-family, and Gentle AI metadata); classify unsupported/conflicting ownership as `unknown`. <!-- sdd-owner: implementation -->
- [ ] Build the complete expected/installed union matrix for assets, templates, skills, configuration fragments, generated metadata, manifests, checksums, directories, symlinks, and binaries; include one sorted row per item with source blob, pinned URL, owner, hashes, comparison rule, and status. <!-- sdd-owner: implementation -->
- [ ] Capture stable IDs for managed binaries, roots, hooks/consumers, native authority, and exactly 11 doctor-reported agents; preserve repository `git status --porcelain=v2 -z` and native status as observations only. <!-- sdd-owner: implementation -->
- [ ] Confirm sealed S0, unchanged `gentle-ai` realpath/hash, known mutation roots, scope-safe official rollback/downgrade route, and resolved GGA commit before invoking the command. <!-- sdd-owner: implementation -->
- [ ] Record pre-operation target snapshots, package identities, no-change sentinels, rollback command, and approved target boundary. <!-- sdd-owner: implementation -->
- [ ] Execute only `gentle-ai upgrade` and receipt argv, executable identity, sanitized environment, output, exit, and target diff. <!-- sdd-owner: implementation -->
- [ ] Re-inventory managed binaries; rerun doctor; syntax-check GGA; verify entrypoint/libraries share compatible official ownership; run isolated documented GGA version/help probes only after syntax and provenance pass. <!-- sdd-owner: implementation -->
- [ ] Accept S1 only when expected versions/probes pass and hooks, shell startup, repository, and native-authority sentinels are byte-identical; on failure mark partial, use only recorded rollback after authorization, then require a fresh baseline. <!-- sdd-owner: implementation -->
- [ ] Confirm S1 passed (or independently proven healthy), sealed complete matrix, only explainable `sync-required` rows, asset rollback, and unchanged binary sentinels. <!-- sdd-owner: implementation -->
- [ ] Execute only `gentle-ai sync`, explicitly receipt that it is asset-only, and capture pre/post manifests and target ownership. <!-- sdd-owner: implementation -->
- [ ] Rebuild the entire matrix from the same pinned authority and boundaries; require unchanged expected-inventory digest and map every changed row to an S0 row plus the sync receipt. <!-- sdd-owner: implementation -->
- [ ] Verify exact bytes/rendered outputs, modes, owners, symlinks, manifests, checksum coverage, generated metadata, and directory contracts; accept only `exact-match` or declared variants. <!-- sdd-owner: implementation -->
- [ ] Stop on any unexplained path, binary change, unknown, conflict, parse failure, or checksum gap; seal partial state and follow official restoration/escalation without a second sync attempt. <!-- sdd-owner: implementation -->
- [ ] Decide `skipped-healthy` only from one canonical executable, supported probe, healthy doctor, known package source, package ownership, and integrity evidence; otherwise prove manager/source, help route, package identity, and rollback before mutation. <!-- sdd-owner: implementation -->
- [ ] If repair is required, execute exactly `gentle-ai install --agent pi` and receipt package root, owner, pre/post identity, exit, and scope. <!-- sdd-owner: implementation -->
- [ ] Re-resolve Pi, verify package database/source/version/hash/integrity, run documented isolated version/help, rerun doctor, and compare all sentinels. <!-- sdd-owner: implementation -->
- [ ] Stop and rollback only through the recorded supported route if delegation, root, candidates, or health differs; require fresh baseline before continuation. <!-- sdd-owner: implementation -->
- [ ] Enumerate exact `opencode` candidates across captured PATH entries, retaining duplicate PATH directories, realpaths, inodes, hashes, owners, and precedence. <!-- sdd-owner: implementation -->
- [ ] Classify alias duplicates versus distinct installations and prove exactly one owner for every candidate through Gentle AI, Homebrew, OS package, npm-family, official installer receipt, or documented user ownership. <!-- sdd-owner: implementation -->
- [ ] Record canonical candidate, owner documentation/version, target preview, exact command, affected paths, and exact restoration command; block if ownership, rollback, or safe command is ambiguous. <!-- sdd-owner: implementation -->
- [ ] After separate approval, execute the one owner command once; re-enumerate candidates and doctor, requiring no duplicate warning and unchanged hooks/startup/repository/native sentinels. <!-- sdd-owner: implementation -->
- [ ] On regression use only the recorded owner rollback; if warning remains or rollback fails, seal and escalate without waiver. <!-- sdd-owner: implementation -->
- [ ] Parse sealed baseline doctor output with a versioned parser and require cardinality exactly 11; block ambiguity rather than dropping records. <!-- sdd-owner: implementation -->
- [ ] Re-run and parse doctor identically; join by stable ID and classify each as unchanged, authorized-change, missing, new, or ambiguous. <!-- sdd-owner: implementation -->
- [ ] For every agent record executable/package candidates, canonical path, supported documented probe, owner, provenance, version, health, and official repair route; require changes to map to exactly one S1–S4 receipt. <!-- sdd-owner: implementation -->
- [ ] Seal the sorted 11-row matrix only with zero unknown, ambiguous, failed supported probes, ownership conflicts, unexplained failures, and duplicate OpenCode warnings; newly needed repair becomes a new scoped unit. <!-- sdd-owner: implementation -->
- [ ] Capture real index checksum, repository status digest, HEAD identities, and nine-path pre-work blob/mode identities without staging, reset, clean, stash, checkout, or reclassification. <!-- sdd-owner: implementation -->
- [ ] Build the synthetic candidate with temporary `GIT_INDEX_FILE`, object directory, alternate objects, `git read-tree HEAD`, exact nine-path `git add`, `write-tree`, `diff-tree`, and archive extraction; verify all temporary paths remain under private probe root. <!-- sdd-owner: implementation -->
- [ ] Require `diff-tree` set equality with exactly the nine manifest paths and expected file types; block missing, extra, renamed, or type-changed paths. <!-- sdd-owner: implementation -->
- [ ] In the candidate tree, derive supported commands from checked-in configuration and run separate JSON/schema validation, `python scripts/verify-theme-health.py`, generated/static parity, `tests/test_token_parity.py`, and `tests/test_theme_health.py` records with exact interpreter/version and scope manifests. <!-- sdd-owner: implementation -->
- [ ] Run shell syntax validation for `scripts/apply-theme-mode.sh` and its documented isolated temporary-target scenario; record `N/A` with exact safety reason when no safe temporary runtime exists. <!-- sdd-owner: implementation -->
- [ ] Validate workflow syntax using the documented local validator when available; treat absent validator as explicit blocker or documented CI dependency, never a fabricated pass. <!-- sdd-owner: implementation -->
- [ ] Require every command exit 0, no undeclared writes, unchanged real index/status/hook/object state, and evidence bound to candidate tree and nine blob IDs; seal Phase 1 manifest and receipt. <!-- sdd-owner: implementation -->
- [ ] Roll back only the nine intended paths from captured identities or owner-reviewed inverse patch; stop if pre-existing intended content cannot be separated, and never use repository-wide reset/checkout/clean/stash. <!-- sdd-owner: implementation -->
- [ ] Parent records locked native authority and stops; do not start/finalize/reconcile/delete/invalidate review lineages until the parent restores eligibility through the native process. <!-- sdd-owner: parent -->
- [ ] After eligibility, parent starts or reuses native bounded review for the exact S6 candidate and nine paths only; any correction remains inside those paths and creates fresh candidate evidence. <!-- sdd-owner: parent -->
- [ ] Before commit, parent stages exactly the nine reviewed paths without content/mode drift and runs `gentle-ai review validate --gate pre-commit --cwd <repo>`; before push/PR, validate the corresponding native gate. <!-- sdd-owner: parent -->
- [ ] Parent blocks commit, push, PR, or terminal mirror reconciliation on missing, scope-changed, invalidated, escalated, or lock-blocked authority. <!-- sdd-owner: parent -->
- [ ] Validate evidence hash chain, redactions, blob digests, stage receipts, domain separation, provenance URLs/commits, target ownership, and final seal; reject changed digests or missing records. <!-- sdd-owner: implementation -->
- [ ] Confirm global evidence never enters repository delivery and no repository path enters global mutation receipts; confirm all prohibited sentinels remain unchanged. <!-- sdd-owner: implementation -->
- [ ] For any failure: stop, capture read-only state, seal stage, obtain explicit recovery authorization, execute only recorded owner rollback, prove restoration in a fresh baseline, and escalate when rollback is unavailable or fails. <!-- sdd-owner: implementation -->

## Deferred parent lifecycle actions

- S7 parent-owned rows remain byte-for-byte unchanged; no native review lifecycle operation occurred.

## Automatic gatekeeper corrective rerun — fresh S0

- **Run:** `/home/dreamcoder08/.local/state/gentle-ai-remediation/20260716T194428Z-s0-retry-2b7f0f13/`
- **Boundary:** read-only S0 only; no task checkboxes changed, no repository implementation/global configuration/binary/hook/PATH/review-state mutation, staging, or commit.
- **Prior evidence:** preserved untouched at `/home/dreamcoder08/.local/state/gentle-ai-remediation/20260716T193922Z-s0-3833df2a/`.
- **Fresh provenance:** GGA tag lookup and Gentle AI authority fetch/verification/detached checkout were receipted. The pinned authority remained `9c7bac8129e7936f414b25830ef591e173ed48ed`.
- **Safe observations completed:** 39 individually receipted records cover command discovery, manager/agent help/version probes other than GGA, package-adapter queries, candidate identities, repository/native-status observations, official authority tree capture, and a six-row safe binary matrix.
- **Matrix result:** `manifests/s0-matrix.json` contains all safe discovered binary rows; each is `unknown-expectation` because a proven managed root, deterministic authority destination mapping, and owner-supported rollback route remain unavailable. No ownership was inferred.
- **Terminal blocker:** `bash -n /home/dreamcoder08/.local/bin/gga` exited `2` in record `000039`. GGA was not invoked, sourced, patched, reinstalled, or repaired forward.
- **Corrected receipt:** `receipts/S0.json` is sealed `blocked`, includes record `000039` explicitly in `stop_reason`, and sets `next_stage_permitted: false`.
- **Rollback:** N/A — both S0 runs are read-only.
- **Status:** blocked pending a fresh authorized S0 completion path that can prove ownership/destination mapping and rollback without overriding the syntax failure.

## New S0 supplemental ownership/provenance unit

- **Evidence root:** `/home/dreamcoder08/.local/state/gentle-ai-remediation/20260716T194740Z-s0-supplemental-102058ce/` (sealed; prior receipts unchanged).
- **Authority:** fetched/read only at Gentle AI `9c7bac8129e7936f414b25830ef591e173ed48ed`; official GGA `v2.10.1` source was fetched/read only at `1124c3672f082c56b033c4e23a30e95d0e8cd593`.
- **Matrix:** `manifests/supplemental-six-row-matrix.json`; receipt: `receipts/S0-supplemental.json`.
- **Resolved observation:** official GGA `install.sh` defines the current non-writable-`/usr/local/bin` Linux layout as `~/.local/bin/gga` plus `~/.local/share/gga/lib/{providers.sh,cache.sh,pr_mode.sh}`. The current entrypoint declares that library directory (record `000063`), and the three libraries were identity-recorded (`000064`–`000069`). This does not establish the current installation's provenance or a Gentle-AI-compatible rollback route.
- **External-state observations:** npm proves `opencode-ai@1.18.2` in the npm global root (`000070`–`000071`); Bun proves the Pi package in its global root (`000072`–`000073`). These do not establish an owner-authorized rollback accepted by the pinned Gentle AI lifecycle. `/usr/bin/opencode`, Gentle AI, and Engram remain without an authoritative owner-to-destination-to-rollback mapping.
- **Official source gap:** the pinned Gentle AI source describes external/package installation and integration boundaries, but contains no installation-state manifest mapping the six observed executable paths to exact owners, destinations, comparison artifacts, and supported restoration procedures. Therefore five rows remain unresolvable from the authority; the GGA row remains blocked by syntax/provenance/rollback.
- **No mutations:** no lifecycle command, GGA invocation, global/repository target edit, task-checkbox update, stage advancement, staging, or commit occurred.
- **Status:** blocked. A bounded mutation-ready plan cannot be issued until owner records and supported rollback procedures are supplied for every target, and GGA's failed syntax is addressed through the proven official owner route.

## Final non-mutating official-route dry-run probe

- **Evidence root:** `/home/dreamcoder08/.local/state/gentle-ai-remediation/20260716T195240Z-s0-dry-run-2718dd66/` (sealed); receipt: `receipts/dry-run.json`.
- `gentle-ai install --component gga --dry-run` — **exit 0**, stderr empty; record `000001`. Plan reports `Components order: gga`, Linux/Arch/pacman supported, `Prepare steps: 2`, `Apply steps: 13`, and no auto-added dependencies. It does not disclose target paths, file/package identities, or a rollback procedure.
- `gentle-ai install --agent pi --dry-run` — **exit 0**, stderr empty; record `000002`. Plan reports `Agents: pi`, `Components order: engram`, Linux/Arch/pacman supported, `Prepare steps: 2`, `Apply steps: 2`, and no auto-added dependencies. It does not disclose target paths, file/package identities, or a rollback procedure.
- **Conclusion:** the CLI exposes an official GGA component-install route, but the dry-run does not establish an owner-supported repair plan for the malformed installed GGA. No GGA was invoked and no target changed.
- **Amendment status:** superseded by the approved GGA-R0 proposal/spec/design/task amendment. That amendment authorizes component recovery only after its same-run eligibility, exact target-plan, ownership, snapshot, and rollback gates pass; S0 remained blocked until those gates could be evaluated.

## GGA-R0 same-run eligibility and stop

- **Evidence root:** `/home/dreamcoder08/.local/state/gentle-ai-remediation/20260716T202451Z-gga-r0-03a1f8a2/` (sealed); decision: `manifests/gga-r0-decision.json`; receipt: `receipts/gga-r0.json`.
- **Invalid probe:** `bash -n /home/dreamcoder08/.local/bin/gga` exited `2` (record `000006`). GGA was not sourced or invoked.
- **Official checker:** source at pinned authority proves `gentle-ai update` is the read-only update-check path (`internal/app/app.go#L427-L430`); the checker exited `0` (record `000014`) and reported `gga installed: -; latest: 2.10.1`, normalized as `gga-version-unknown`.
- **Eligibility evidence:** invalid probe, unknown-version checker, same run, and recorded repository/GGA/library sentinels all matched before/after the checker. The derived decision was persisted and its prerequisite evidence is complete.
- **Dry-run:** `gentle-ai install --component gga --dry-run` exited `0` (record `000019`) and did not change the recorded GGA, library, or repository sentinels. Its output only reports aggregate counts (`Prepare steps: 2`, `Apply steps: 13`); it has no operation rows, target paths, owner roots, source artifacts/commits, expected identities, or rollback actions.
- **Stop:** GGA-R0 is sealed `blocked` because the dry-run cannot be parsed into the required exact target plan. No snapshots, backup/rollback plan, or component install command was authorized or run. No upgrade, sync, Pi, OpenCode, repository, hook, PATH, or review-state mutation occurred.
- **Checkboxes:** three GGA-R0 evidence/decision rows were marked complete. Target extraction and all mutation/precondition/validation rows remain unchecked.

## Requested exception rejected at safety gate

- **Request:** execute `gentle-ai install --component gga` despite the sealed GGA-R0 plan-opacity blocker, after backing up `~/.local/bin/gga`, `~/.local/share/gga`, and `~/.config/gga`.
- **Decision:** blocked before mutation or backup. The approved GGA-R0 design explicitly prohibits the install without an exact parsed target set, installer ownership, and owner-supported rollback. User authorization does not establish those missing safety facts.
- **Secret boundary:** byte-preserving backup of `~/.config/gga` is not permitted because that root may contain provider/credential material; the evidence contract forbids capturing it. No content in that root was read or copied.
- **Outcome:** no command, snapshot, backup, task checkbox, or global/repository target changed. Existing sealed GGA-R0 receipt remains authoritative.
- **Required unblocker:** a pinned, machine-readable installer plan (or authority-pinned parser) with exact GGA-only targets plus an owner-supported rollback for every target; a secret-safe metadata-only config sentinel may then be defined separately.

## Apply reconciliation — current approved work-unit

- **Delivery / boundary:** approved work-unit chain; this apply attempt was limited to reconciling the authoritative artifact state and current read-only health facts. No implementation task was eligible for completion.
- **Structured status consumed:** `artifactStore=openspec`; `apply=ready`; `verify=blocked`; `archive=blocked`; `nextRecommended=apply`; `actionContext.mode=repo-local`; workspace and sole allowed edit root: `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- **Artifact and ownership checks:** proposal, design, tasks, apply-progress, and all three specifications (`global-gentle-ai`, `dreamcoder-phase1`, `review-and-gates`) are present. All checkbox ownership markers are terminal and valid. Parent-owned S7 rows were not changed.
- **Current read-only facts reconciled:** `gga --version` returned `gga v2.10.1`; `type -a opencode` exposed one effective candidate at `/home/dreamcoder08/.local/share/npm-global/bin/opencode`; npm reports `opencode-ai@1.18.2`; `gentle-ai doctor` returned `8 passed, 0 failed, 0 warnings`. These observations are not a sealed S0 receipt.
- **Blocker:** prior S0 and GGA-R0 receipts remain sealed `blocked` because they lack the complete managed-root ownership, deterministic target/matrix, and owner-supported rollback evidence required by the approved tasks. The new health observations do not retroactively satisfy or amend those sealed receipts. Therefore S1–S6 are not dependency-ready, and no lifecycle/global/repository mutation is authorized.
- **Native authority:** the locked review/correction lineages remain parent-owned. No review status mutation, review actor, staging, commit, push, PR, or receipt claim occurred.
- **Persisted task state:** no checkbox changed; no implementation-owned task is reported complete from this work unit.
- **Files changed:** `openspec/changes/repair-gga-and-theme-delivery/apply-progress.md` only.
- **Commands run:** `gga --version` (pass); `type -a opencode` (one effective candidate); `npm list -g opencode-ai --depth=0` (reports `1.18.2`); `gentle-ai doctor` (8/8 pass); read-only artifact and ownership-marker audits.
- **TDD:** not active per `openspec/config.yaml`; no production code was written.
- **Deviation:** the direct `gga --version` reconciliation probe ran without first creating a fresh sealed S0 record and re-running `bash -n` on the current entrypoint. It produced the reported healthy result and made no mutation, but it is not valid GGA conformance evidence and no checkbox was advanced. This stop otherwise preserves the sealed-stage and parent-owned-native-authority boundaries.
- **Next safe work unit:** a newly authorized fresh S0 baseline that records the now-healthy GGA/OpenCode/doctor facts while producing the still-missing ownership, deterministic matrix/target, and supported rollback evidence. It is read-only but must be explicitly scoped as a new sealed evidence run; it cannot alter prior sealed receipts.

## Fresh sealed S0 baseline — approved read-only work unit

- **Delivery / boundary:** `auto-chain` / `feature-branch-chain`, S0 evidence slice only. This is a new sealed run and does not alter any earlier receipt.
- **Evidence root:** `/home/dreamcoder08/.local/state/gentle-ai-remediation/20260716T212713Z-s0-fresh-8750e071/` (mode `0500`; contents `0400`; 32 append-only records and a manifest seal).
- **Result:** `blocked`; `receipts/S0.json` sets `next_stage_permitted: false`. No lifecycle installer/upgrade/sync, package operation, PATH/shell/hook/repository content mutation, staging, commit, or native review mutation/lock operation occurred.

### Structured status consumed

```yaml
changeName: repair-gga-and-theme-delivery
artifactStore: openspec
applyState: ready
dependencies: { apply: ready, verify: blocked, archive: blocked }
actionContext:
  mode: repo-local
  workspaceRoot: /home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots
  allowedEditRoots: [/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots]
warnings: []
nextRecommended: apply
```

### Evidence summary

- Pinned Gentle AI authority was fetched, verified, and read without executing fetched code: `9c7bac8129e7936f414b25830ef591e173ed48ed` (records `000002`–`000006`). Official GGA `v2.10.1` resolves to `1124c3672f082c56b033c4e23a30e95d0e8cd593` (`000001`).
- GGA target identity: `/home/dreamcoder08/.local/bin/gga`, SHA-256 `53ebb131508d439c09e63855960012d2ec772aca11824d85670a257d030b9a8c`. `bash -n` passed (`000021`) **before** `gga --version` and `gga --help`; version returned `gga v2.10.1` (`000022`). The three declared library identities are recorded in `manifests/gga-library-declarations.json` and the matrix.
- Gentle AI: `2.1.6`; doctor exited `0` with `8 passed, 0 failed, 0 warnings` (`000012`–`000014`). Doctor reports **12** installed agents, not the task/design-required 11; the line-filter inventory is therefore explicitly `unknown`, never coerced to eleven.
- OpenCode has one effective PATH candidate: npm-global symlink `/home/dreamcoder08/.local/share/npm-global/bin/opencode` -> `.../opencode-ai/bin/opencode.exe`; `npm list -g` reports `opencode-ai@1.18.2` (`000024`–`000026`). This is npm installation evidence, not a complete owner-authorized resolution or rollback proof.
- `manifests/s0-expected-installed-matrix.json` is deterministically sorted and records every safely observed binary/library row as `unknown-expectation`. The pinned authority did not yield a proven managed-root/destination/owner/rollback mapping. No ownership was inferred.
- Repository sentinels and native SDD status were observed only (`000028`–`000031`). `gentle-ai review inspect` is unavailable in this CLI (`000032`, exit 1); it did not mutate authority. No downstream review authorization is claimed.

### Persisted task update

- Marked `[x]` only: `Independently receipt command -v, type -a, version/help/doctor probes ... canonicalize each candidate ...` The fresh run supplies the complete independently receipted discovery/probe and identity evidence. All other unchecked implementation rows remain unchanged.

### Stop / escalation

S0 cannot pass because the expected/installed matrix lacks deterministic official destination, ownership, and owner-supported rollback mappings; the required 11-agent inventory also conflicts with the observed doctor count of 12. The safe next scope is a read-only authority/owner-record acquisition that can establish those mappings and reconcile the stated cardinality. Mutation remains unauthorized.

### Verification

- Read-only evidence runner: `python3 /tmp/s0_baseline.py` (32 records; sealed blocked receipt).
- No TDD: `openspec/config.yaml` declares `strict_tdd: false`; no production code was written.
- Workload / PR boundary: external read-only S0 evidence only; no repository PR content.
- Deferred parent lifecycle actions: all S7 parent-owned rows remain byte-for-byte unchanged.

## 12-agent contract reconciliation and official ownership evidence

- **Delivery / boundary:** `auto-chain` / `feature-branch-chain`; assigned slice is external, read-only S0 evidence only. No configuration, package, binary, PATH, shell, hook, repository, staging, commit, review-authority, or native-lock mutation occurred.
- **Structured status consumed:** `artifactStore=openspec`; `apply=ready`; `verify=blocked`; `archive=blocked`; `nextRecommended=apply`; `actionContext.mode=repo-local`; workspace and only allowed edit root: `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`. Warning: external evidence was intentionally written outside that root as explicitly authorized; repository edits were limited to this progress report.
- **Evidence:** `/home/dreamcoder08/.local/state/gentle-ai-remediation/20260716T220000Z-agent-contract-evidence/agent-contract-reconciliation.json` (SHA-256 `131e5000b678a85f25fd85f9be61d53dc7ebdd9e734d524caed1a8e43eb2d18d`, private/read-only).
- **Inventory:** the current state-selected and doctor-reported set is exactly 12: `claude-code`, `opencode`, `kilocode`, `gemini-cli`, `cursor`, `vscode-copilot`, `codex`, `antigravity`, `kimi`, `qwen-code`, `pi`, and `hermes`.
- **Reconciliation:** the twelfth item is `hermes`. Pinned authority `9c7bac8129e7936f414b25830ef591e173ed48ed` explicitly documents Hermes as a supported detect-only integration; therefore the conflict is a **plan/version drift from the required 11-row contract**, not evidence of a duplicate or unmanaged agent. The 11-agent S5 task cannot be completed without a plan/spec correction.
- **Provenance and owner evidence:** official authority confirms Gentle AI is an ecosystem configurator, state-selected agents define sync/backup configuration scope, Pi is package-managed, and Hermes is detect-only. Supported package metadata proves runtime-package ownership only for OpenCode (`opencode-ai@1.18.2`), Codex (`@openai/codex@0.144.5`), Pi (`@earendil-works/pi-coding-agent@0.80.9`), Gemini (`gemini-cli 1:0.50.0-1`), VS Code (`visual-studio-code-bin 1.128.1-1`), and Antigravity (`antigravity 2.2.1-1`). It does not prove owners for Claude Code, Kilo Code, Cursor, Kimi, Qwen Code, or Hermes.
- **Rollback/destination result:** pinned rollback documentation supports configuration snapshot/restore for state-selected Gentle-AI-managed config only and explicitly excludes external package rollback. It provides no per-machine runtime-binary destination or exact owner-supported restoration mapping for the 12 candidates, Gentle AI, Engram, GGA, or the GGA libraries. These missing mappings remain blockers; no ownership was inferred.
- **Persisted tasks:** no checkbox changed. No implementation-owned unchecked row is fully proven: the S0 stable-ID row requires exactly 11 agents; the ownership/matrix rows require destination and rollback mappings; S5 requires a complete 11-row matrix. Parent-owned S7 rows were preserved byte-for-byte.
- **Commands / verification:** read-only `jq` selection of `~/.gentle-ai/state.json`; commit-pinned `git show` documentation reads; read-only `pacman -Qo`; npm/Bun package-manifest metadata reads. TDD is inactive; no production code or tests apply.
- **Deviation:** the authority checkout working tree had pre-existing modified files, so all authority claims were read from immutable commit objects with `git show <commit>:<path>`, never from that working tree.
- **Stop / next safe work unit:** blocked. A planning correction must change the 11-agent acceptance/task contract to the official 12-agent selected set (or explicitly remove one through a separately authorized owner route), and authoritative owner-to-destination-to-rollback mappings must be supplied for every mutation-relevant target. This work unit does not authorize any mutation or phase advancement.
