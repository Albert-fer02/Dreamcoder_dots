# Proposal: Harden Theme Design System

## Intent

Establish an auditable, terminal-first design-system core for Dreamcoder themes. The change will make token semantics, mode parity, contrast expectations, generated-artifact validation, and CI enforcement explicit and trustworthy without introducing disruptive palette churn or attempting broad screenshot-baseline coverage for every renderer.

The immediate product outcome is that maintainers can change or regenerate terminal-facing themes with clear rules and receive a reliable blocking signal when a mode, state, contrast requirement, or generated artifact is invalid. The existing unexpected OpenCode generated-artifact health failure must be explained and resolved at its source rather than ignored, allowlisted without justification, or hidden by weakening validation.

## Current-State Gap

The project has canonical theme tokens, WCAG/APCA guardrails, three modes (`dark`, `light`, and `dusk`), and health tooling, but the design-system contract is not yet sufficiently auditable:

- Token roles are not consistently expressed as explicit layers from palette primitives through semantic and component/state usage.
- Mode parity, especially for `dusk`, is not defined as an enforceable invariant across the terminal-first target set.
- Interactive states and their foreground/background contrast obligations are not captured in one reviewable matrix.
- Health checks can produce unexpected generated-artifact failures without a sufficiently clear diagnosis and remediation path.
- CI trust depends on validation being deterministic, scoped correctly, and blocking when the contract is violated.

## Scope

### 1. Auditable layered token model

- Formalize token layers where the existing architecture can support them without disruptive palette replacement:
  - canonical palette/primitives;
  - semantic roles such as background, text, accent, border, focus, and status;
  - terminal/component roles and interaction states.
- Define ownership and derivation rules so generated/static token representations cannot silently diverge from the canonical token source.
- Preserve current visual identity and existing colors unless a narrowly scoped adjustment is required to satisfy a documented contrast or parity rule.
- Treat broad palette redesign, renaming churn, and unrelated renderer normalization as out of scope.

### 2. Mode parity, including dusk

- Define the required token and state contract for `dark`, `light`, and `dusk`.
- Identify the terminal-first targets subject to parity enforcement and make omissions or unsupported mappings explicit rather than silently falling back.
- Require generated outputs to remain attributable to their mode inputs and canonical token definitions.
- Preserve intentional mode-specific differences when documented; parity means equivalent supported roles and states, not identical color values.

### 3. State and contrast matrix

- Specify a reviewable matrix covering the terminal-first core's meaningful foreground/background and interaction-state combinations, including at minimum normal text, muted text, selected text, focus, borders where perceptually significant, and semantic status states.
- Define which checks use WCAG contrast ratios, which use APCA, and which threshold applies by content/state and mode.
- Preserve the existing baseline of WCAG 4.5:1 minimum text contrast and the canonical APCA body thresholds, including the mode-aware dark-background policy, unless the specification documents a stricter requirement.
- Ensure failures identify the mode, token/state pair, measured result, required threshold, and affected target or generated artifact.

### 4. Trustworthy health validation and blocking CI

- Make theme-health validation deterministic, actionable, and non-optional for the scoped terminal-first contract.
- Ensure CI fails when required mode parity, state/contrast policy, canonical/generated synchronization, or generated-artifact health is violated.
- Distinguish genuine design-system failures from stale, malformed, unexpectedly discovered, or incorrectly scoped generated artifacts without suppressing real defects.
- Keep local validation and CI behavior aligned so maintainers can reproduce failures before opening or updating a change.

### 5. Resolve the OpenCode generated-artifact failure

- Reproduce and classify the current unexpected OpenCode generated-artifact health failure.
- Determine the artifact's intended ownership, generation path, mode coverage, and validation scope.
- Correct the source, generation contract, artifact expectation, or validator classification responsible for the failure.
- Add focused regression coverage proving that the valid OpenCode artifact passes and equivalent drift or corruption fails.
- Do not resolve the issue by globally weakening health checks or introducing an unexplained permanent exception.

## Affected Areas

Expected affected areas for later implementation and specification refinement include:

- `themes/dreamcoder/tokens.json` and its schema or documented token contract;
- generated/static token synchronization, including `src/dreamcoder_theme/palette_tokens.py`;
- contrast and adaptive-palette validation in `src/dreamcoder_theme/palette.py`;
- terminal-facing renderers and orchestration under `src/dreamcoder_theme/renderers_*.py`, `renderers.py`, and `sync.py` only where needed for parity or artifact correctness;
- OpenCode generation or generated-artifact ownership paths;
- `scripts/verify-theme-health.py` and focused test coverage;
- CI workflows that execute theme-health validation;
- concise maintainer documentation for the matrix, failure interpretation, and local reproduction.

Exact implementation paths must be confirmed during design; this proposal does not authorize unrelated renderer refactors.

## Non-Goals

- Building screenshot-baseline or visual-regression infrastructure for every supported target in this slice.
- Redesigning the Dreamcoder palette or broadly changing its visual identity.
- Achieving semantic-token perfection across all 28+ renderers before the terminal-first core can be enforced.
- Rewriting the theme engine, renderer architecture, or generation pipeline without evidence that a scoped contract cannot be enforced otherwise.
- Expanding target support or adding new modes.
- Treating visual snapshots as a substitute for token, parity, state, contrast, and artifact-integrity checks.

## Constraints and Invariants

- `themes/dreamcoder/tokens.json` remains the canonical token source; generated/static representations must follow the canonical workflow.
- All three supported modes—`dark`, `light`, and `dusk`—must be represented explicitly in the scoped contract.
- Existing WCAG/APCA guardrails cannot be weakened merely to make current output pass.
- Pure black/white avoidance and current visual identity should be preserved where feasible.
- Validation must be deterministic in CI and reproducible locally without depending on an operator's active theme or machine-specific generated state.
- Generated artifacts must have explicit ownership and provenance; unexpected files must produce an actionable classification.
- Implementation must isolate pre-existing working-tree modifications and generated/untracked files.
- No source-code changes are part of this proposal phase.

## Success Criteria

1. A documented layered-token contract identifies canonical, semantic, and terminal/component-state responsibilities without requiring broad palette churn.
2. The scoped terminal-first targets have an explicit parity definition for `dark`, `light`, and `dusk`; missing required roles, states, or mode outputs fail validation with actionable diagnostics.
3. A state/contrast matrix defines required pairings and the applicable WCAG/APCA policy, including mode-aware thresholds.
4. Theme-health validation produces deterministic results locally and in CI and reports enough context to identify the failing mode, state/token pair, threshold or invariant, and affected artifact/target.
5. CI blocks merges when the scoped design-system contract fails and passes when canonical inputs and generated outputs are healthy.
6. The existing OpenCode generated-artifact failure is reproducible, root-caused, and corrected without suppressing equivalent future failures.
7. Focused automated coverage proves valid OpenCode generation/validation and detects representative stale, malformed, parity-breaking, or contrast-breaking cases.
8. Existing terminal visuals remain materially stable except for documented, minimal corrections required by the contract.
9. No all-target screenshot-baseline infrastructure is required for completion of this slice.

## Risks and Mitigations

- **Hidden palette churn:** Layering or contrast fixes could unintentionally alter established visuals. Mitigate with derivation-focused changes, explicit before/after review of affected terminal outputs, and narrow color exceptions only when policy requires them.
- **False confidence from incomplete parity:** A check may report success while omitting dusk or an important state. Mitigate by deriving validation from an explicit required matrix rather than from only the keys present in each mode or artifact.
- **Noisy or brittle CI:** Environment-dependent generation can create false failures. Mitigate by validating canonical inputs and deterministic generated content in isolated temporary state, with diagnostics that distinguish drift from tool failure.
- **Validator weakening to fix OpenCode:** A quick allowlist could conceal real corruption. Mitigate by requiring a root-cause classification and focused negative regression case before accepting the resolution.
- **Scope expansion across 28+ targets:** Token cleanup can become an all-renderer redesign. Mitigate by freezing this slice around the auditable terminal-first core and recording other targets as follow-up work.
- **WCAG/APCA policy ambiguity:** Different metrics can disagree or be applied to unsuitable states. Mitigate by specifying metric ownership per matrix row and treating policy changes as explicit product/design decisions.
- **Generated-source divergence:** Manual edits to static/generated token files can drift from canonical data. Mitigate with provenance rules and synchronization checks that identify the canonical corrective action.

## Rollback

Implementation must remain reversible by separating contract enforcement from unrelated visual changes. If blocking validation causes unanticipated operational disruption:

1. Revert the scoped validator/CI enforcement and associated generator changes together to the last known healthy contract.
2. Restore generated artifacts from canonical inputs using the previous supported generation path rather than hand-editing outputs.
3. Preserve diagnostics and the OpenCode root-cause record for follow-up; do not permanently disable existing baseline health checks.
4. Any temporary CI downgrade must be explicit, time-bounded, and tracked as a blocking follow-up rather than silently converted into a warning.

## Proposal Question Round

The delegated brief establishes the first-slice direction, so this proposal records the smallest remaining product questions for user review rather than blocking creation:

1. Which targets define the terminal-first core for parity enforcement: only terminal emulators, or also terminal-adjacent UI such as Starship, tmux, and OpenCode?
2. Should every matrix violation block immediately, or may newly documented non-text APCA observations begin as informational while WCAG text and established APCA body requirements remain blocking?
3. When a target cannot represent a semantic state directly, is an explicit documented mapping acceptable, or must the target be excluded from the enforced parity set?
4. Is OpenCode expected to be a checked-in generated artifact, an ephemeral generated output, or both under different workflows?

Current assumptions pending correction:

- The terminal-first core includes terminal emulators plus terminal-adjacent surfaces that consume the same theme contract, with the exact inventory finalized in the specification.
- Existing WCAG and APCA body requirements remain blocking; no threshold is weakened in this slice.
- Explicit semantic mappings are acceptable when a target format lacks a one-to-one concept, but silent omission is not.
- The OpenCode artifact's intended lifecycle will be determined from repository evidence; the fix will enforce that lifecycle rather than assume checked-in or ephemeral ownership.
