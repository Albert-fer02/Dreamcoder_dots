# Ghostty Theme Rollout Specification

## Purpose

Define the narrowly scoped, evidence-backed remediation for the confirmed Ghostty 1.3.1-arch2 base-configuration parser errors. This change MUST NOT claim or implement the broader Dreamcoder theme rollout. Herdr remains outside scope.

## Requirements

### Requirement: Capture version-tied baseline evidence

The repair MUST record the Ghostty 1.3.1-arch2 identity, resolved active managed configuration path, changed source location, and baseline default active-configuration validation before editing.

#### Scenario: Baseline reproduces the attributed errors

- GIVEN the active XDG Ghostty root resolves to the repository-managed `DreamcoderGhostty/.config/ghostty` tree
- AND the managed base config contains `window-title` and `tab-title` without `config-file` directives
- WHEN the default active configuration is validated with Ghostty `+validate-config`
- THEN the evidence records both `window-title: unknown field` and `tab-title: unknown field`
- AND the evidence includes the version-tied local documentation showing `title` as the supported fixed window-title setting

### Requirement: Apply only proven base-config remediation

The repair MUST modify only the repository-managed base configuration containing the proven-invalid fields. It MUST remove unsupported `tab-title` and MUST NOT invent a substitute for it.

#### Scenario: Unsupported tab title is removed

- GIVEN Ghostty 1.3.1-arch2 local documentation does not support `tab-title`
- WHEN the remediation is applied
- THEN the `tab-title` assignment is removed from the managed base config
- AND no replacement tab-title behavior is added

#### Scenario: Fixed window title is intentionally retained

- GIVEN preserving the existing fixed window title remains the intended behavior
- AND Ghostty 1.3.1-arch2 documents `title` for that behavior
- WHEN the remediation is applied
- THEN `window-title` is replaced by the documented `title` setting with the existing intended fixed title

#### Scenario: Fixed window title is not intentionally retained

- GIVEN preserving the existing fixed window title is not intended
- WHEN the remediation is applied
- THEN the unsupported `window-title` assignment is removed
- AND no substitute title behavior is invented

### Requirement: Validate the default active configuration before and after

The repair MUST use the same default active Ghostty configuration path and `+validate-config` behavior before and after the edit.

#### Scenario: Post-remediation validation passes the narrow acceptance boundary

- GIVEN the minimal base-config remediation is complete
- WHEN default active configuration validation runs after the edit
- THEN neither `window-title` nor `tab-title` is reported as an unknown field
- AND no new configuration error is introduced
- AND sanitized before/after diagnostics are recorded

### Requirement: Preserve the broader rollout evidence gate

The change MUST leave broader Ghostty rollout behavior unchanged and MUST keep claims about it contingent on tracing the complete parsed configuration graph.

#### Scenario: Broader work remains deferred

- GIVEN the complete Ghostty parsed include graph is not yet traceable
- WHEN this change is implemented or verified
- THEN theme includes and ordering, renderer behavior, generated Light/Dark variants, installation and repair, mode selection, activation, synchronization, and full rollout are not modified or claimed as validated
- AND the implementation and verification evidence explicitly states that those areas remain deferred

### Requirement: Preserve unrelated configuration and palette behavior

The repair MUST preserve unrelated non-theme Ghostty settings, canonical palette tokens, contrast guardrails, generated theme data, and operational flows.

#### Scenario: Scope is limited to the two source assignments

- GIVEN the managed base config contains unrelated settings
- WHEN the remediation is applied
- THEN only the proven-invalid title assignments change
- AND palette, renderer, include, installation, synchronization, selection, and activation behavior remains unchanged

### Requirement: Exclude Herdr

This change MUST NOT add, modify, validate, install, remove, or otherwise alter Herdr configuration or integration.

#### Scenario: Herdr remains untouched

- GIVEN historical Herdr findings exist separately
- WHEN this Ghostty remediation is implemented or verified
- THEN Herdr files, ownership, startup references, and behavior remain unchanged
- AND any Herdr work is deferred to a separate approved change
