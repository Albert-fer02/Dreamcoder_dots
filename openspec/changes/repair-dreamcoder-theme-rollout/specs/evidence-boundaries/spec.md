# Evidence Boundaries Specification

## Purpose

Ensure rollout evidence, rollback, and acceptance claims are limited to this change's declared scope.

## Requirements

### Requirement: Dirty-worktree changes are excluded from authored evidence

Pre-existing dirty-worktree changes MAY inform discovery but MUST NOT be treated as authored scope, acceptance evidence, rollback material, or proof of this change. Evidence MUST bind to declared paths and an explicit baseline.

#### Scenario: Baseline contains unrelated edits

- GIVEN the worktree is dirty before a rollout slice begins
- WHEN implementation, verification, or rollback evidence is collected
- THEN unrelated paths and changes MUST be excluded and the report MUST state the exclusion

### Requirement: Historical overlapping SDD artifacts remain cross-referenced

The master specification MUST identify `harden-theme-design-system` as prerequisite design-system input, `implement-herdr-dreamcoder-themes` as gated input, `repair-gga-and-theme-delivery` as evidence-discipline input, and the prior Ghostty-only specifications as historical/superseded planning input. Existing artifacts MUST NOT be deleted or silently rewritten.

#### Scenario: A prior artifact conflicts with this rollout

- GIVEN an overlapping artifact contains a narrower or stale target contract
- WHEN downstream planning consumes specifications
- THEN this master change MUST control future rollout behavior and the prior artifact MUST remain available as historical evidence
