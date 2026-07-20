# Proposal: Repair Global Gentle AI Installation and Deliver Dreamcoder Theme Phase 1

## Intent

Bring the complete global Gentle AI installation into verifiable conformance with the official lifecycle documented at Gentle AI commit `9c7bac8129e7936f414b25830ef591e173ed48ed`, while preserving installer and package ownership. Separately prepare Dreamcoder Theme Phase 1 for delivery using exactly nine repository paths.

This change addresses two related but independently controlled outcomes:

1. The global Gentle AI installation, including GGA, Pi, managed assets, and all 11 reported agents, is current, healthy, provenance-verifiable, and managed only through official ownership routes.
2. Dreamcoder Theme Phase 1 is evidenced and deliverable without incorporating any of the workspace's 93 pre-existing dirty paths outside the approved nine-path manifest.

The duplicate OpenCode PATH warning is a blocking acceptance criterion. The change must establish ownership and resolve the duplication safely. It may not be waived as a documented warning.

## Problem

The exploration records the following evidence and gaps:

- Official lifecycle authority distinguishes managed binary refresh (`gentle-ai upgrade`) from managed asset refresh (`gentle-ai sync`). Treating sync as binary repair could leave GGA broken while reporting success.
- The installed GGA entrypoint was observed as a malformed v2.10.0 shell script, preventing a reliable version probe, while the official latest version was reported as v2.10.1. A separate repository checkout is v2.6.1 and is evidence only, not a valid replacement.
- New read-only evidence reports that the upgrade checker classifies the installed GGA version as unknown, while `gentle-ai install --component gga --dry-run` succeeds with a plan of 2 prepare actions and 13 apply actions. Official components guidance identifies this command as the global GGA provisioning route. The dry-run is evidence of a viable plan, not authorization to apply it.
- Pi is package-managed and therefore requires the official `gentle-ai install --agent pi` repair route when repair is justified. New read-only evidence reports that its dry-run succeeds.

## Plan amendment boundary

This amendment is required before any mutation because the prior proposal allowed only `gentle-ai upgrade` for GGA, despite the broken entrypoint preventing a valid probe and the upgrade checker reporting its installed version as unknown. It conditionally adds the official component-provisioning route described below. Amending this plan does **not** authorize execution of `gentle-ai upgrade`, `gentle-ai install --component gga`, or any other mutating command. Mutation remains gated by later approved planning, ownership/provenance evidence, pre-target snapshots, supported rollback proof, and all existing stop conditions.

- Doctor reportedly detects 11 agents and a duplicate OpenCode PATH warning. The warning's ownership and precedence are not yet proven.
- The Dreamcoder workspace reportedly contains 93 pre-existing dirty paths, so repository-wide status cannot define Phase 1 delivery scope.
- Native review authority is locked by unrelated correction-required lineages. This change must not alter, bypass, reconcile, invalidate, or delete those lineages.

These observations are inputs requiring revalidation during execution, not claims that repair has already occurred.

## Objectives

1. Produce a reproducible, read-only baseline inventory of the complete global Gentle AI installation.
2. Prefer `gentle-ai upgrade` for managed binary refresh when installed-version probes are valid and the upgrade lifecycle can identify the managed target.
3. When GGA cannot provide a valid probe and the upgrade checker reports its version as unknown, allow conditional recovery only through the official `gentle-ai install --component gga` provisioning route after its dry-run, source/provenance, pre-target snapshot, target scope, and supported rollback have been proven.
4. Synchronize managed assets only through `gentle-ai sync`, without representing sync as binary repair.
5. Repair Pi, when baseline evidence shows repair is required, only through `gentle-ai install --agent pi`.
6. Audit all 11 doctor-reported agents for path, version/probe result, ownership, provenance, health, and official repair route.
7. Prove GGA executable and library ownership, syntax, version, provenance, and non-destructive runtime health after the applicable official upgrade or conditional component-install recovery route.
8. Identify the owner and precedence of every OpenCode PATH candidate and eliminate the duplicate warning through an official owner-authorized mechanism.
9. Keep Dreamcoder Phase 1 delivery limited to its exact nine-path manifest and produce scoped health, schema, parity, and generated/static synchronization evidence.
10. Preserve all unrelated repository dirt and native review authority state.
11. Produce evidence and rollback instructions for every mutating work unit.

## Scope

### Global Gentle AI installation

The global work includes:

- Gentle AI management identity: executable path, installation root, version, package or installer provenance, update channel, and governing authority commit.
- Every managed binary and its version probe result, distinguishing probe failure from absence.
- Managed assets, templates, skills, configuration fragments, generated metadata, manifests, and checksums.
- All 11 doctor-reported agents, including executable/package path, ownership classification, version, health, and official repair route.
- Engram path, version, ownership, and managed-state evidence.
- Pi package identity, package manager/source, health, and official repair readiness.
- GGA entrypoint, required libraries, syntax, version, hashes, ownership, and provenance.
- OpenCode PATH candidates, precedence, ownership, duplicate-warning cause, and safe resolution.
- Read-only discovery of hooks and consumers that reference managed executables.

### Dreamcoder Theme Phase 1

Repository delivery is limited to exactly these paths:

1. `.github/workflows/theme-validation.yml`
2. `DreamcoderThemes/dreamcoder/tokens.json`
3. `DreamcoderThemes/dreamcoder/tokens.schema.json`
4. `docs/DREAMCODER_DESIGN_SYSTEM.md`
5. `scripts/apply-theme-mode.sh`
6. `scripts/verify-theme-health.py`
7. `src/dreamcoder_theme/palette_tokens.py`
8. `tests/test_token_parity.py`
9. `tests/test_theme_health.py`

Phase 1 evidence must cover the approved manifest, token/schema validity, static/generated parity, theme-health guardrails, focused tests, and the exact environment and command results used.

## Non-goals

- Manually copying or patching managed Gentle AI, GGA, or Pi binaries.
- Using the v2.6.1 GGA repository checkout as a replacement for an officially managed installation.
- Claiming `gentle-ai sync` updates or repairs binaries.
- Blindly deleting an OpenCode executable, PATH entry, symlink, package, or configuration fragment.
- Directly rewriting PATH or shell startup files without separate ownership evidence and an approved, independently reversible work unit.
- Modifying, reinstalling, or deleting repository hooks.
- Modifying OpenCode review state or any native review authority lineage.
- Cleaning, resetting, staging, stashing, or reclassifying the 93 pre-existing dirty workspace paths.
- Expanding Dreamcoder Phase 1 beyond the nine approved paths.
- Implementing later theme refinements or unrelated generated-file cleanup.
- Bypassing a failed probe, unresolved provenance, review lock, or partial operation to obtain a nominally successful result.

## Official conformance rules

The following rules are mandatory:

1. Official authority is Gentle AI commit `9c7bac8129e7936f414b25830ef591e173ed48ed`. The exact authority must be recorded with execution evidence.
2. `gentle-ai upgrade` remains the preferred route for refreshing Gentle AI-managed binaries when installed-version probes are valid and the upgrade checker can identify the managed version.
3. For GGA only, when the entrypoint cannot provide a valid probe and the upgrade checker reports the installed version as unknown, `gentle-ai install --component gga` is an allowed conditional recovery route because official components guidance documents it as global GGA provisioning. Before execution, its successful dry-run plan must be retained and reviewed, and the official source, installer provenance, exact target paths, pre-target snapshots/hashes, compatibility, and supported rollback route must be proven.
4. A successful `gentle-ai install --component gga --dry-run` is planning evidence only. It neither proves that the apply phase will succeed nor authorizes mutation.
5. `gentle-ai sync` is restricted to managed asset synchronization and must be receipted separately from binary refresh or component recovery.
6. Pi repair must use exactly `gentle-ai install --agent pi`; no manual copying or generic sync may substitute for it. Its successful dry-run is planning evidence only.
7. A failed or unavailable version probe is a failure requiring diagnosis, not proof that an installation is current. For GGA, that diagnosis may justify the conditional official component-install recovery route after all preconditions are satisfied.
8. Managed targets must retain official installer/package ownership and compatible versions. Files from unrelated checkouts may be used only as evidence.
9. GGA must be syntax-checked before any invocation of an entrypoint known or suspected to be malformed.
10. Every mutating command requires pre-operation ownership evidence, target-path capture, hashes or package identity, and a documented restoration route.
11. OpenCode resolution requires proof of each candidate's owner and precedence. Resolution is permitted only through the owning installer/package manager or another separately approved, evidence-backed mechanism.
12. No direct PATH rewrite, blind deletion, hook change, or review-state mutation is authorized by this proposal.
13. If the duplicate OpenCode warning cannot be removed without one of those prohibited actions, execution must stop and escalate for a separately scoped decision. Overall acceptance remains blocked until a safe resolution is approved, executed, and verified.
14. Facts observed from commands must be distinguished from documentation-derived expectations. Evidence must include command, sanitized environment, timestamp, output, and exit status.
15. Credentials, tokens, provider secrets, and unrelated user data must not be captured.

## Proposed work units

Each work unit is independently reviewable and reversible. Completion of one unit does not authorize the next when a stop condition is present.

### Work unit 1 — Read-only global baseline

Inventory management identity, binaries, assets, all 11 agents, Engram, Pi, GGA libraries, OpenCode PATH candidates, hooks/consumers, and repository status. Record reproducible evidence without mutation.

- **Verification:** complete inventory schema; command outputs and exit statuses; ownership and provenance classifications; explicit unknowns.
- **Rollback:** not applicable because the unit is read-only.

### Work unit 2 — Managed binary refresh and conditional GGA recovery

After baseline ownership is proven, prefer `gentle-ai upgrade` when valid installed-version probes allow the upgrade lifecycle to identify managed targets. If GGA remains unrepairable through that route because its probe is invalid and the upgrade checker reports its installed version as unknown, the work unit may conditionally use the officially documented `gentle-ai install --component gga` global provisioning route.

The component route must not run until its dry-run plan has been retained and reviewed; official source and provenance are established; every target path and library is enumerated; pre-target snapshots and hashes are captured; compatibility is checked; and an installer-supported rollback or restoration procedure is proven. The reported dry-run plan of 2 prepare actions and 13 apply actions must be reconciled with the expected ownership boundary before mutation. Any mismatch stops the unit.

- **Verification:** selected-route rationale; dry-run output and action count when component recovery is selected; official source/provenance; exact pre/post versions, paths, hashes or package identity; GGA syntax; required-library resolution; non-destructive help/version behavior; and doctor output.
- **Rollback:** official downgrade/reinstall, component restoration, or installer-supported package recovery proven before mutation; never an ad hoc file copy.
- **Authorization boundary:** this proposal amendment defines a conditional route but does not authorize its execution.

### Work unit 3 — Managed asset synchronization

Run `gentle-ai sync` as an asset-only operation after binary health is established, or when the audit independently proves asset synchronization is required.

- **Verification:** pre/post asset manifests, checksums, ownership, command result, and confirmation that binary identities were not represented as sync outputs.
- **Rollback:** restore through the official asset lifecycle or captured pre-sync manifest mechanism proven before mutation.

### Work unit 4 — Pi package-managed repair

If baseline evidence shows Pi is missing, stale, or unhealthy, run exactly `gentle-ai install --agent pi`.

- **Verification:** package source and identity, executable path, version, health, and doctor result.
- **Rollback:** package-manager or official installer route captured before repair.

### Work unit 5 — OpenCode ownership and duplicate resolution

Identify every OpenCode PATH candidate, owning installer/package/user, canonical path, precedence, and reason for duplication. Resolve the warning only through the proven owner-authorized mechanism.

- **Verification:** before/after PATH resolution, candidate identities and hashes, ownership evidence, official command or approved mechanism, unchanged hooks/review state, and doctor output with no duplicate warning.
- **Rollback:** exact owner-supported restoration command or reversible configuration/package action captured before mutation.
- **Boundary:** direct PATH rewriting, blind deletion, hook mutation, and review-state mutation remain prohibited. If no safe mechanism is available, stop and escalate; do not waive the blocker.

### Work unit 6 — Complete 11-agent reconciliation

Re-run the full inventory after all authorized repairs and verify every reported agent against official ownership and health expectations.

- **Verification:** all 11 agents accounted for with valid path/probe/ownership/health evidence and no unexplained failures.
- **Rollback:** read-only reconciliation; any newly discovered repair becomes a separately authorized work unit rather than an in-place improvisation.

### Work unit 7 — Dreamcoder Phase 1 delivery preparation

Collect and validate only the nine approved paths. Run focused theme-health, schema, parity, and synchronization checks without touching unrelated workspace state.

- **Verification:** exact nine-path manifest, scoped diff identity, commands and results, token/schema validation, generated/static parity, health guardrails, tests, and runtime scenario or explicit N/A.
- **Rollback:** revert or remove only the intended Phase 1 changes within those nine paths, preserving pre-existing content through captured pre-work identities.

### Work unit 8 — Native review and delivery gate

Parent/orchestrator or maintainer resolves the unrelated authority lock through the native process. Once eligible, review and gate only the intended Phase 1 content-bound scope.

- **Verification:** native authority confirms a valid receipt for the exact intended content and paths.
- **Rollback:** governed by native review authority; this work unit must not edit or bypass unrelated lineages.

## Acceptance criteria

### Global installation

1. The official authority commit and lifecycle commands used are recorded.
2. A complete evidence-backed inventory accounts for managed binaries, managed assets, Engram, Pi, GGA, OpenCode, and all 11 agents.
3. Managed binary refresh uses `gentle-ai upgrade` when probes are valid. If the conditional GGA component route is required, evidence proves why upgrade could not identify the installed GGA version and proves that `gentle-ai install --component gga` followed the reviewed dry-run, official source/provenance, exact target boundary, pre-target snapshot, and supported rollback plan.
4. GGA passes shell syntax validation before invocation, resolves its officially owned required libraries, reports the expected officially managed version, and passes non-destructive help/version checks after the selected official route.
5. No binary is sourced from the unrelated v2.6.1 checkout or another unproven location.
6. `gentle-ai sync` completes as an independently evidenced asset operation, with asset manifests current and no claim that it repaired binaries.
7. Pi is healthy and package-owned; if repaired, evidence proves use of `gentle-ai install --agent pi`.
8. All 11 agents have known ownership, paths, valid probes where supported, and no unexplained health failure.
9. The canonical OpenCode executable and every competing PATH candidate have proven ownership and precedence.
10. Doctor no longer reports the duplicate OpenCode PATH warning.
11. OpenCode resolution evidence proves no blind deletion, direct PATH rewrite, hook change, or review-state mutation occurred.
12. Post-operation versions, paths, hashes/package identities, provenance, command results, and doctor output are recorded without secrets.

### Dreamcoder Phase 1

1. Delivery scope contains exactly the nine approved paths and no others.
2. Evidence is derived from the intended nine-path content, not inferred from the 93-path workspace status.
3. Token/schema checks, static/generated parity, theme-health guardrails, and focused tests pass with exact command results recorded.
4. The approved Phase 1 scope receives a valid content-bound native review receipt before commit, push, or PR delivery.
5. No unrelated dirty path or native authority artifact is staged, reset, cleaned, altered, or included.

### Overall success

The change is successful only when both the global installation criteria and Dreamcoder Phase 1 criteria pass. A remaining duplicate OpenCode PATH warning, unresolved ownership, failed probe, partial repair, or missing receipt blocks completion.

## Stop and escalation conditions

Stop the current work unit immediately and preserve evidence when any of the following occurs:

- Ownership or provenance of a target is missing, conflicting, or changes unexpectedly.
- `gentle-ai upgrade`, `gentle-ai install --component gga`, `gentle-ai sync`, or `gentle-ai install --agent pi` exits unsuccessfully or produces a partial result.
- The GGA component dry-run differs from the retained 2-prepare/13-apply plan without an explained and re-approved authority change.
- GGA component source/provenance, exact targets, pre-target snapshots, compatibility, or supported rollback cannot be proven before mutation.
- A command proposes or performs mutation outside its proven ownership boundary.
- GGA fails syntax, library resolution, version, provenance, or non-destructive invocation checks after the selected official recovery route.
- A version probe is unavailable or inconsistent with package/installer metadata.
- Any of the 11 agents develops a new or unexplained health failure.
- OpenCode duplication cannot be resolved through a proven owner-authorized mechanism.
- OpenCode resolution would require direct PATH rewriting, blind deletion, hook changes, review mutation, or another action not separately approved.
- Hooks, shell startup files, credentials, provider configuration, or unrelated user data would be exposed or changed.
- Any Dreamcoder path outside the nine-path manifest would be mutated, staged, or included.
- Pre-existing workspace content cannot be distinguished from intended Phase 1 content.
- The unrelated native review lock prevents creation or validation of the exact intended receipt.
- A rollback route cannot be proven before mutation.

Escalation must identify the blocked work unit, observed evidence, affected ownership boundary, safe alternatives with tradeoffs, and the smallest additional scope required. It must not repair forward over an unexamined partial state.

## Affected areas

- Global Gentle AI installer-managed binaries and assets.
- GGA entrypoint and officially managed library installation.
- Pi package-managed installation.
- Agent discovery and health reporting for all 11 agents.
- OpenCode executable discovery, ownership, and PATH precedence.
- Dreamcoder theme tokens, schema, validation workflow, documentation, runtime mode script, generated static tokens, and focused tests within the nine approved paths.
- Native review scheduling and gate eligibility, without mutation of existing authority state.

## Risks and mitigations

- **Critical — lifecycle confusion:** Asset sync could be mistaken for binary repair. Mitigation: separate commands, evidence, acceptance, and rollback receipts.
- **Critical — ownership destruction:** Manual GGA, Pi, or OpenCode changes could break future upgrades. Mitigation: require official owner-authorized operations and stop on ambiguity.
- **High — unsafe OpenCode resolution:** Removing the warning could damage PATH precedence or another installation. Mitigation: blocking ownership proof, no blind deletion/rewrite, reversible owner-supported action only.
- **High — partial global mutation:** A failed operation could leave mixed versions. Mitigation: pre-operation snapshots/package identity, stage-specific stop conditions, and no repair-forward behavior.
- **High — review authority corruption:** Unrelated correction lineages could be altered to unblock delivery. Mitigation: parent-owned native handling and explicit prohibition on review-state mutation.
- **High — workspace contamination:** The 93 dirty paths could enter Phase 1 evidence or delivery. Mitigation: fixed nine-path manifest and content-bound scope verification.
- **Medium — health false confidence:** Doctor success may not prove token parity or provenance. Mitigation: independent probes, hashes/package identity, schema, parity, and focused tests.
- **Medium — evidence leakage:** Inventory could expose credentials or unrelated data. Mitigation: sanitized environment and output with secrets excluded.

## Delivery boundaries

- Global installation work and repository Phase 1 delivery must remain separate evidence and rollback domains.
- Each mutating global work unit must be completed, verified, and receipted before the next begins.
- OpenCode resolution is its own work unit and blocks overall acceptance, but does not authorize direct PATH, hook, or review mutation.
- Dreamcoder Phase 1 may include only the nine listed paths, regardless of repository-wide status.
- Existing review lineages remain immutable. Native review begins or validates only when the parent/maintainer has restored eligibility through official authority handling.
- No commit, push, or PR is authorized by this proposal. Those actions require later task, apply, verification, and native gate phases.

## Rollback strategy

Rollback is defined per ownership domain rather than as a repository-wide reset:

- **Baseline and reconciliation:** read-only; no rollback.
- **Managed binaries:** official downgrade/reinstall or installer-supported restoration based on captured pre-operation package/version provenance. Conditional GGA component recovery additionally requires restoration coverage for every dry-run target and captured pre-target identity before apply.
- **Managed assets:** official asset restoration or pre-sync manifest mechanism proven before synchronization.
- **Pi:** package-manager or official installer rollback.
- **OpenCode:** owner-supported restoration of the exact changed package/configuration boundary; no broad PATH reset.
- **Dreamcoder Phase 1:** restore only intended changes in the nine-path manifest using captured pre-work identities, without overwriting unrelated pre-existing modifications.
- **Native review:** authority-owned recovery only; never filesystem deletion or manual lineage mutation.

A work unit must not mutate state until its exact rollback command or supported restoration procedure is documented and checked for scope.

## Review workload forecast

- **Risk tier:** High. The change spans global executables, package ownership, PATH precedence, partial-failure recovery, a dirty repository, and locked native review authority.
- **Chained PRs recommended:** Yes for repository delivery if the intended authored Phase 1 diff exceeds 400 changed lines or cannot be reviewed as one coherent unit. Global machine remediation is not to be mixed into a repository PR.
- **400-line budget risk:** Unknown until the exact nine-path intended diff is isolated. The 93-path workspace total must not be used for this estimate.
- **Decision needed before apply:** Yes. Apply must not start until baseline ownership is available, the OpenCode safe-resolution mechanism is defined, rollback routes are proven, and the parent has addressed native review eligibility for eventual Phase 1 delivery.
- **Review focus:** resilience for global command/partial-failure handling, risk for ownership/PATH/provenance boundaries, and reliability for the nine-path theme evidence. Any later implementation must follow the native bounded-review classifier rather than opening reviews ad hoc.

## Proposal question round

The user clarified that the duplicate OpenCode PATH warning is a blocking acceptance criterion. The proposal therefore requires ownership identification and safe resolution, while preserving the prohibition on blind deletion, direct PATH rewrites, hook changes, and review-state mutation. If those constraints prevent resolution, execution stops and escalates; the warning cannot be waived.

## Success criteria summary

Success means the official Gentle AI lifecycle has produced a fully evidenced, healthy, provenance-correct global installation; all 11 agents are reconciled; GGA and Pi satisfy their official ownership routes; the duplicate OpenCode PATH warning is safely eliminated; and Dreamcoder Theme Phase 1 is validated and deliverable as exactly nine paths with no contamination from unrelated workspace or review state.
