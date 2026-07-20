# Herdr 0.7.3 Runtime Diagnosis

## Evidence decision

A fresh, read-only diagnostic pass during the 2026-07-16 UTC design-validation session established a narrow current-state fact: the repository's Herdr switch path is reached, but its external Light/Dark candidate filenames contain the opposite canonical mode anchors. This evidence is time-bounded to that single diagnostic pass and does not establish continued host state after the commands completed.

This artifact is additive. It does not revise or replace [`runtime-inspection.md`](./runtime-inspection.md). That older inspection remained correctly inconclusive because it did not inspect candidate values, did not attribute parser behavior to a concrete parsed path, and did not exercise the switch chain. The observations below come from the later fresh-context diagnosis in this session.

No external Herdr file was written, renamed, relinked, reloaded, or printed in full during the diagnosis.

## Observed evidence

| Fact                     | Reproducible observation                                                                                                                                                                                                                                               | Bound of the claim                                                                                                                                 |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------- |
| Installed version        | `herdr --version` reported `herdr 0.7.3`.                                                                                                                                                                                                                              | Version output only; no schema compatibility follows from it.                                                                                      |
| Switch chain             | Read-only tracing of the `dreamcoder dark` path resolved through `scripts/dreamcoder.sh`, which dispatches to `scripts/apply-theme-mode.sh`; that script dispatches to `scripts/herdr-theme-switch.sh dark`. The same source path selects `light` for a Light request. | Establishes the exact repository dispatch chain observed during this pass, not which file a running Herdr process parsed.                          |
| Dark selector            | The diagnosed Dark path had `<HOME>/.config/herdr/config.toml -> config.dark.toml`; `scripts/herdr-theme-switch.sh` maps `dark` to that relative target and maps `light` to `config.light.toml`.                                                                       | Establishes the observed selector identity and script behavior, not runtime consumption because `HERDR_CONFIG_PATH` may override the default path. |
| Dark filename semantics  | A read-only anchor comparison found Dreamcoder Light anchors in `<HOME>/.config/herdr/config.dark.toml`, including canonical Light background `#f3eadc` and accent `#824f16`.                                                                                          | Proves a semantic filename/content mismatch for the inspected file at that moment; it is not complete schema validation.                           |
| Light filename semantics | A read-only anchor comparison found Dreamcoder Dark anchors in `<HOME>/.config/herdr/config.light.toml`, including canonical Dark background `#070A13` and accent `#A5C7E8`.                                                                                           | Proves the inverse semantic mismatch for the inspected file at that moment; it is not complete schema validation.                                  |
| Production renderer      | `src/dreamcoder_theme/renderers_herdr.py::update_herdr_config()` intentionally returns `False`, while `herdr_content()` raises `HerdrContractUnavailableError`.                                                                                                        | Confirms production rendering/active mutation is deliberately gated; it does not prove a valid Herdr profile.                                      |
| Reload handling          | `scripts/herdr-theme-switch.sh` runs `herdr server reload-config 2>/dev/null                                                                                                                                                                                           |                                                                                                                                                    | true`. | Any stderr and non-zero status are swallowed, so the caller cannot use this path as evidence of reload success. |

## Reproduction recipe

Run from the repository root in a read-only diagnostic shell. Do **not** invoke `dreamcoder dark|light` or `herdr server reload-config` merely to reproduce this evidence, because those commands can mutate the selector or runtime state.

```bash
herdr --version

# Inspect the static command chain without executing it.
grep -nE 'APPLY_SCRIPT|apply-theme-mode\.sh' scripts/dreamcoder.sh
grep -nE 'HERDR_SCRIPT|herdr-theme-switch\.sh' scripts/apply-theme-mode.sh
sed -n '1,80p' scripts/herdr-theme-switch.sh

# Confirm the observed selector identity without changing it.
test -L "$HOME/.config/herdr/config.toml"
test "$(readlink "$HOME/.config/herdr/config.toml")" = 'config.dark.toml'

# Confirm the fail-closed renderer boundary.
grep -nE 'def herdr_content|def update_herdr_config|return False|HerdrContractUnavailableError' \
  src/dreamcoder_theme/renderers_herdr.py

# Compare only canonical anchors; do not print complete external configs.
for value in '#f3eadc' '#824f16'; do
  grep -Fqi -- "$value" "$HOME/.config/herdr/config.dark.toml" || exit 1
done
for value in '#070A13' '#A5C7E8'; do
  grep -Fqi -- "$value" "$HOME/.config/herdr/config.light.toml" || exit 1
done

# Confirm the reload command masks both diagnostics and failure.
grep -nF 'herdr server reload-config 2>/dev/null || true' scripts/herdr-theme-switch.sh
```

The anchor checks are case-insensitive because hexadecimal color case has no semantic significance. Passing them establishes only the two observed fingerprints. It does not authorize rewriting, selecting, validating, or activating either candidate.

## Remaining unproven facts

The diagnosis does **not** prove:

- the complete Herdr 0.7.3 configuration schema or an authoritative version-tied schema source;
- an isolated candidate validator or a safe command that validates without activating;
- whether a running process parsed `<HOME>/.config/herdr/config.toml` rather than a `HERDR_CONFIG_PATH` override;
- ownership or safe migration rights for `config.toml`, `config.dark.toml`, or `config.light.toml`;
- reload exit semantics, because the current script discards stderr and forces success;
- that any running process accepted or applied either candidate;
- observable runtime or UI convergence to Light or Dark;
- complete token-role coverage, structural parity, or absence of unsupported fields; or
- continued presence of the same version, files, selector, or contents after the diagnostic pass.

Accordingly, this evidence supports detection and truthful `unsupported-contract` reporting only. It does not open the Herdr production gate and does not support a renderer, validator, production activation, reload-success claim, or observable UI confirmation.
