# Global Gentle AI Remediation Specification

## Purpose

Restore and verify the globally managed Gentle AI installation without breaking installer, package, or ownership boundaries.

## Requirements

### Requirement: Baseline inventory and evidence

The remediation MUST begin with a read-only inventory of the Gentle AI manager, managed binaries and assets, Engram, Pi, GGA, all 11 doctor-reported agents, OpenCode PATH candidates, and referenced hooks or consumers. Each record MUST distinguish command-observed evidence from documentation-derived expectations and include sanitized command, timestamp, output, and exit status.

#### Scenario: Complete baseline is captured

- GIVEN the global installation may contain stale, malformed, missing, or duplicate targets
- WHEN the baseline audit runs
- THEN every required domain is recorded with path, ownership, provenance, probe result, health result, and explicit unknowns
- AND credentials, tokens, provider secrets, and unrelated user data are excluded

### Requirement: Official binary upgrade and conditional GGA recovery

Managed binaries MUST be refreshed through `gentle-ai upgrade`, which remains the preferred route when installed-version probes are valid and the upgrade lifecycle can identify the managed target. When GGA's existing probe is invalid and `gentle-ai upgrade` cannot establish GGA health, `gentle-ai install --component gga` MAY be used as a conditional official recovery route only after a successful `--dry-run`, commit-pinned provenance, an exact pre-target snapshot, proven installer-owned targets, and a documented supported rollback. A successful dry-run MUST NOT be treated as authorization to mutate. Manual copying or patching MUST NOT be used.

#### Scenario: Valid probes use the preferred upgrade route

- GIVEN baseline evidence proves managed ownership, valid installed-version probes, and rollback provenance
- WHEN the binary refresh is performed
- THEN `gentle-ai upgrade` is used
- AND post-upgrade paths, versions, hashes or package identities, provenance, exit status, and doctor output are recorded

#### Scenario: Invalid GGA probe permits conditional recovery

- GIVEN GGA's existing probe is invalid
- AND `gentle-ai upgrade` cannot establish GGA health
- WHEN the conditional recovery decision is evaluated
- THEN the component route is permitted only if `gentle-ai install --component gga --dry-run` succeeds, provenance is pinned to the approved authority commit, exact target snapshots are captured, targets are proven installer-owned, and supported rollback is documented
- AND failure of any prerequisite blocks the route and acceptance

#### Scenario: Conditional GGA recovery is verified

- GIVEN every conditional recovery prerequisite has passed
- WHEN `gentle-ai install --component gga` is applied
- THEN GGA syntax, required-library resolution, version, non-destructive help/version behavior, provenance, and doctor health all pass
- AND the command result and pre/post target identities are recorded

### Requirement: Managed asset synchronization

Managed assets MUST be refreshed only through `gentle-ai sync`, with an independent pre/post asset manifest and receipt. The asset receipt MUST state that the operation does not refresh binaries.

#### Scenario: Asset sync is independently verified

- GIVEN binary health is established or the audit independently proves assets require synchronization
- WHEN `gentle-ai sync` completes
- THEN changed asset paths, ownership, checksums, exit status, and rollback route are recorded separately from binary evidence

### Requirement: Pi package repair

Pi MUST remain package-owned. When baseline evidence shows Pi is missing, stale, or unhealthy, repair MUST use exactly `gentle-ai install --agent pi`; manual copying and generic synchronization MUST NOT substitute for it.

#### Scenario: Pi repair is required

- GIVEN Pi repair is justified by baseline evidence
- WHEN the official Pi install command runs
- THEN package source and identity, executable path, version, health, command result, and doctor result prove package ownership and health

### Requirement: GGA conformance

GGA MUST be syntax-checked before invoking a malformed or suspect entrypoint. After the applicable official route (`gentle-ai upgrade`, or the conditional component recovery route), it MUST resolve its officially owned required libraries, report the expected managed version, pass non-destructive help/version checks, and not use the unrelated v2.6.1 checkout as a replacement. Any failed verification MUST block acceptance.

#### Scenario: GGA passes the applicable official route

- GIVEN `gentle-ai upgrade` succeeded, or all prerequisites for conditional component recovery were satisfied and the component install completed
- WHEN syntax, library-resolution, provenance, version, help/version, and doctor checks run
- THEN all checks pass with paths and hashes or package identities recorded
- AND GGA is accepted only after every check passes

### Requirement: Agent reconciliation

The final audit MUST account for all 11 doctor-reported agents with executable or package path, version or probe failure, ownership, provenance, health, and official repair route. No unexplained agent failure MAY remain.

#### Scenario: All agents reconcile

- GIVEN authorized repairs and synchronization are complete
- WHEN the full doctor and agent inventory rerun
- THEN all 11 agents have complete evidence and doctor reports no unexplained failure

### Requirement: OpenCode duplicate ownership resolution

Every OpenCode PATH candidate MUST have proven owner, canonical path, identity, and precedence before mutation. The duplicate warning MUST be removed only through an owner-authorized, separately reversible mechanism; blind deletion, direct PATH rewriting, hook mutation, and review-state mutation are prohibited.

#### Scenario: Safe duplicate resolution succeeds

- GIVEN all candidates and their owners are documented
- WHEN an owner-authorized resolution is applied
- THEN before/after resolution, candidate identities, precedence, command result, rollback route, unchanged hooks, and unchanged review state are recorded
- AND doctor reports no duplicate OpenCode PATH warning

### Requirement: Global rollback boundaries

Every mutating work unit MUST capture target paths, pre-operation hashes or package identity, ownership, and an exact supported restoration route before mutation. Conditional GGA recovery additionally MUST capture the exact pre-target snapshot and prove installer ownership for every target identified by the dry-run. Rollback MUST affect only that ownership domain and MUST NOT use ad hoc file copies.

#### Scenario: Partial mutation is recoverable

- GIVEN a mutating command exits unsuccessfully or produces unexpected state
- WHEN the work unit stops
- THEN evidence is preserved and the documented owner-supported restoration route is available without repair-forward behavior

### Requirement: Global stop conditions

Execution MUST stop and escalate when ownership or provenance is ambiguous, a lifecycle command fails or is partial, a probe is unavailable or inconsistent without satisfying the conditional GGA recovery prerequisites, any conditional recovery prerequisite fails, GGA fails validation, a new agent failure appears, OpenCode cannot be safely resolved, a prohibited target would be mutated, secrets would be exposed, or rollback cannot be proven. Manual copies or patches MUST never be used as an alternative.

#### Scenario: Blocking condition occurs

- GIVEN any required stop condition is observed
- WHEN the condition is detected
- THEN the current work unit stops without waiver or compensating mutation
- AND escalation identifies evidence, ownership boundary, safe alternatives with tradeoffs, and the smallest additional scope required
