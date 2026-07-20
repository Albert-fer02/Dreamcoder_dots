# Ghostty Evidence Specification

## Purpose

Preserve the completed Ghostty parser repair as narrow, version-bound evidence while defining broader rollout work as separately required.

## Requirements

### Requirement: Ghostty evidence is version-bound

The completed parser remediation MUST record the Ghostty version, resolved active managed path, source location, and before/after validation claim. Evidence for Ghostty 1.3.1-arch2 MUST NOT be generalized to other versions or to full rollout behavior.

#### Scenario: Version differs from recorded evidence

- GIVEN Ghostty is absent or its version differs from the recorded baseline
- WHEN the narrow repair is evaluated
- THEN the evidence MUST be marked version-gated and MUST NOT establish compatibility for the unverified version

### Requirement: Unsupported title fields remain absent

The managed base configuration MUST NOT restore unsupported `window-title` or `tab-title` keys; a supported fixed title MAY use the recorded documented `title` setting only when that behavior is intentionally retained.

#### Scenario: Narrow validation runs

- GIVEN the recorded Ghostty version and managed path are used
- WHEN `+validate-config` runs after remediation
- THEN neither unsupported title field may be reported and no unrelated configuration error may be introduced

### Requirement: Broader Ghostty rollout requires manifest evidence

The narrow repair MUST NOT be treated as proof of Ghostty theme rendering, installation, switching, reload, rollback, or parsed include-graph coverage. Those claims remain prerequisite/deferred until the target manifest contract is independently evidenced.

#### Scenario: Historical Ghostty-only specification is consulted

- GIVEN the stale Ghostty-only change specification exists
- WHEN this master change is planned or verified
- THEN it MUST be cross-referenced as historical input and superseded planning authority, without deletion or modification
