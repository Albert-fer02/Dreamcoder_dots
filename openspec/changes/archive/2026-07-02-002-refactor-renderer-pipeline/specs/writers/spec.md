# Writers Specification — Variant Files

## Purpose

Filesystem writers for Dreamcoder theme variant file generation.

## Requirements

### Requirement: write_variant_files_and_active composes two operations

The system SHALL provide `write_variant_files_and_active(base, names, builder,
variants, active)` that calls `write_variant_files` followed by `write_if_changed`
for the active-mode file, returning a combined changes list.

#### Scenario: Variants written then active file

- GIVEN base dir, a 2-mode names map, a builder, variants dict, and active palette
- WHEN `write_variant_files_and_active(...)` is called
- THEN variant files are written first, then the active file, in order

#### Scenario: Active file is skipped when unchanged

- GIVEN the active file already contains the builder output for the active palette
- WHEN `write_variant_files_and_active(...)` is called
- THEN `write_variant_files` runs but active file write returns False

### Requirement: write_variant_files contract unchanged

The existing `write_variant_files(base, names, builder, variants)` SHALL
retain its current signature and behavior.

#### Scenario: Existing callers unbroken

- GIVEN any existing call site using `write_variant_files`
- WHEN the refactor is applied
- THEN the call signature and return type are unchanged
