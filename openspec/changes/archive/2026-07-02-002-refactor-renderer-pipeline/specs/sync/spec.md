# Sync Registry & Repo Snippets Specification

## Purpose

Declarative variant file sync for Dreamcoder theme repository snippets.

## Requirements

### Requirement: VARIANT_REGISTRY drives sync_repo_snippets

`sync_repo_snippets()` SHALL read a declarative `VARIANT_REGISTRY` list and
iterate it to produce variant files and active-file writes. The registry MUST
capture: target directory, filename map, content builder, and optional active
path.

#### Scenario: Registry produces identical file set

- GIVEN dark/light variant palettes and an active dark palette
- WHEN `sync_repo_snippets()` runs with the declarative registry
- THEN the set of written files and their content match the pre-refactor output

#### Scenario: Registry entries match current variant blocks

- GIVEN the pre-refactor `sync_repo_snippets()` with ~18 variant blocks
- WHEN counting entries in `VARIANT_REGISTRY`
- THEN registry contains 18+ entries covering all variant+active combinations

### Requirement: Registry preserves insertion order

Entries in `VARIANT_REGISTRY` SHALL be iterated in definition order so that
write-order is deterministic and matches the pre-refactor append order.

#### Scenario: Write order is deterministic

- GIVEN a `VARIANT_REGISTRY` with ordered entries A, B, C
- WHEN `sync_repo_snippets()` runs
- THEN files from entry A are written before B, and B before C

### Requirement: hyprland/waybar/rofi and nvim entries stay direct

Hyprland, Waybar, Rofi, and nvim variant+active writes SHALL remain as
direct calls in `sync_repo_snippets()` — not registered in `VARIANT_REGISTRY`.

#### Scenario: WM entries excluded from registry

- GIVEN the `VARIANT_REGISTRY`
- WHEN scanning for hyprland/waybar/rofi entries
- THEN none are present; they execute as direct calls below the registry loop
