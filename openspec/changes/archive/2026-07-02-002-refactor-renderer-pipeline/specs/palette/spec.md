# Palette Mode Detection & ANSI Specification

## Purpose

Mode detection and ANSI color generation for the Dreamcoder theme palette.

## Requirements

### Requirement: detect_mode returns canonical mode string

The system MUST provide `detect_mode(palette)` that returns `"dark"` when
`palette["details"] == "darker"` and `"light"` otherwise. All renderers MUST
use this single implementation.

#### Scenario: Dark palette detected

- GIVEN palette with `{"details": "darker"}`
- WHEN `detect_mode(palette)` is called
- THEN returns `"dark"`

#### Scenario: Light palette detected

- GIVEN palette with `{"details": "light"}`
- WHEN `detect_mode(palette)` is called
- THEN returns `"light"`

#### Scenario: Unknown details value

- GIVEN palette with `{"details": "unknown"}`
- WHEN `detect_mode(palette)` is called
- THEN returns `"light"` (default)

#### Scenario: Missing details key

- GIVEN palette without `"details"` key
- WHEN `detect_mode(palette)` is called
- THEN returns `"light"` (default)

### Requirement: ansi uses detect_mode internally

The `ansi()` function SHALL call `detect_mode()` instead of inlining the
`"darker"` comparison, producing identical output.

#### Scenario: ANSI output unchanged after refactor

- GIVEN a palette dict with known background and token values
- WHEN `ansi(palette)` is called
- THEN the returned list of hex colors matches the pre-refactor output exactly

### Requirement: No ad-hoc mode detection in renderers

After the refactor, no renderer module SHALL contain the literal pattern
`c["details"] == "darker"` or local `_detect_mode` / `_mode` functions.
All mode detection MUST delegate to `palette.detect_mode(c)`.

#### Scenario: Mode detection grep clean

- GIVEN the full `src/dreamcoder_theme/` source tree
- WHEN grepping for `c["details"] == "darker"` or `def _detect_mode` or `def _mode`
- THEN zero matches found in renderer modules
