# Review and Delivery Gates Specification

## Purpose

Keep global remediation, repository delivery, and native review authority separate and verifiable.

## Requirements

### Requirement: Independent ownership domains

Global installation remediation and Dreamcoder Phase 1 delivery MUST use separate evidence, rollback, and acceptance domains. Global machine changes MUST NOT be mixed into a repository delivery scope.

#### Scenario: Domains remain separated

- GIVEN both global and repository work are underway
- WHEN evidence, rollback, or delivery scope is reviewed
- THEN each record identifies exactly one domain
- AND no global target appears in the nine-path repository manifest

### Requirement: Native review authority boundary

Existing native review lineages and authority state MUST remain immutable. No actor MAY alter, reconcile, invalidate, delete, or bypass unrelated correction-required lineages.

#### Scenario: Review lock remains present

- GIVEN unrelated native review lineages block ordinary review
- WHEN Phase 1 preparation or global remediation executes
- THEN the lock is reported to the parent or maintainer
- AND no filesystem or authority mutation is used to bypass it

### Requirement: Content-bound delivery gate

Before commit, push, or pull request delivery, the exact nine-path intended content MUST have a valid native content-bound review receipt. A receipt for unrelated or broader workspace content MUST NOT satisfy the gate.

#### Scenario: Exact receipt is validated

- GIVEN Phase 1 checks pass and delivery is otherwise eligible
- WHEN the native gate validates the candidate
- THEN the receipt covers exactly the approved content and paths
- AND any missing, changed, invalid, or escalated authority state blocks delivery

### Requirement: Stop and escalation reporting

A blocked gate or unresolved safety condition MUST produce a concise escalation naming the blocked work unit, observed evidence, affected ownership boundary, safe alternatives with tradeoffs, and smallest additional scope required. Acceptance MUST remain blocked until the condition is resolved.

#### Scenario: Gate cannot authorize delivery

- GIVEN the duplicate OpenCode warning, unresolved ownership, failed probe, partial repair, scope contamination, or missing receipt remains
- WHEN acceptance is evaluated
- THEN the change is not marked successful and no waiver is recorded
- AND the blocking evidence is retained for the next authorized phase
