# Installation and Activation Specification

## Purpose

Define safe ML4W/Gentleman installation, repair, explicit/scheduled switching, idempotency, and bounded rollback for Light/Dark.

## Requirements

### Requirement: Installation classifies ownership before mutation

Install and repair MUST classify each destination as fresh/missing, repository-managed, external symlink, external regular file, missing-parent, partial managed state, or conflict before mutation. Only missing or repository-managed destinations MAY be provisioned or repaired automatically. External content MUST NOT be silently adopted, overwritten, or deleted.

#### Scenario: External destination is encountered

- GIVEN a destination is an external symlink or regular file
- WHEN repair runs without explicit migration
- THEN the destination MUST remain unchanged and the result MUST report conflict or migration-required guidance

#### Scenario: Managed destination is stale

- GIVEN a destination is repository-managed and stale
- WHEN repair runs
- THEN it MUST restore the declared artifact idempotently and leave unrelated user content unchanged

### Requirement: Explicit and scheduled switching share one boundary

Explicit and scheduled selection MUST invoke the same Light/Dark application boundary and MUST converge selectors, generated active files, and observable consumers to the requested mode. No entrypoint MAY activate `dusk`.

#### Scenario: Both paths select Dark

- GIVEN equivalent initial state and valid managed Light/Dark artifacts
- WHEN explicit selection and scheduling each request Dark
- THEN both MUST produce equivalent final state, per-target outcomes, and aggregate exit semantics

### Requirement: Switching is idempotent

Applying an already-active valid mode MUST change no managed content or selector and MUST avoid unnecessary reloads where observability permits. The result MUST distinguish `unchanged` from `applied`.

#### Scenario: Requested mode is already active

- GIVEN all required selectors and consumers already represent Light
- WHEN Light is applied again
- THEN no selector or content write MUST occur and no unnecessary reload MUST be attempted

### Requirement: Required activation failures are bounded and recoverable

The application boundary MUST capture prior managed content and selector state before mutation. If a required validation, write, selector, or reload step fails after mutation, it MUST restore affected rollback-capable state, revalidate the prior mode where supported, and report initiating and rollback outcomes separately. External paths MUST never be used as rollback destinations.

#### Scenario: Reload fails after a selector change

- GIVEN at least one managed target changed and a required reload fails
- WHEN rollback runs
- THEN prior managed state MUST be restored where supported and the result MUST be `rolled-back`; if restoration is unproven it MUST be `rollback-failed` and list residual inconsistent targets

### Requirement: Health output exposes aggregate truth

Health output MUST summarize required successes, optional successes, actionable skips, failures, and rollback status. Suppressed validator or reload errors MUST be prohibited.

#### Scenario: One target fails in a fan-out

- GIVEN multiple targets are processed and one required target fails
- WHEN the operation completes
- THEN the output MUST identify the target and phase, return non-success, and include all rollback or residual-state findings
