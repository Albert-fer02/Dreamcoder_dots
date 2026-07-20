# Exploration: Implement Herdr Dreamcoder Themes

## Executive finding

Herdr is a confirmed local executable target, not a renderer typo: the inspected runtime is `herdr 0.7.3`, identified by help as the terminal workspace manager at `herdr.dev`. The repository already attempts mode switching, but it does not own or generate Herdr configuration. The active, dark, and light files observed on the host are external user-owned files containing onboarding state only; no palette is configured there, so the visible purple cannot be attributed to those files.

A first-class integration is feasible in the existing theme engine, but implementation MUST remain gated by a version-tied Herdr configuration contract. The prior historical inspection must remain unchanged; this exploration uses its sanitized runtime evidence only and does not modify external configuration.

## Runtime contract and capability evidence

- Installed identity: `herdr 0.7.3`; the inspected executable digest and Linux platform are recorded in the separate historical runtime inspection.
- Default config path documented by `herdr --help`: `<HOME>/.config/herdr/config.toml`.
- Environment override documented by help: `HERDR_CONFIG_PATH`; its value was intentionally not inspected.
- `herdr config --help` exposes only `reset-keys`; no authoritative schema or validation command was discovered.
- `herdr server reload-config` is documented and takes no options, but exit semantics were not exercised. A running process was detected by executable name only, not by proven parsed config path.
- Therefore no Herdr color field, TOML representation, validator, or reliable reload-success contract is currently proven. The implementation must not guess keys or emit unsupported fields. Proposal/design should make runtime-contract verification a prerequisite, or define a conservative compatibility profile only for fields proven by fresh evidence.

## Current local ownership and integration gap

The host currently has external regular files at `~/.config/herdr/config.dark.toml` and `config.light.toml`, plus an active `config.toml` symlink observed targeting the light file. They are not repository paths and are not installed by Stow. The repository contains no Herdr config variants or schema declaration.

`src/dreamcoder_theme/installer.py` manages Kitty, Ghostty, Shell, Bat, Warp, and systemd targets, but no Herdr module/path. `scripts/herdr-theme-switch.sh` assumes the external variants already exist, flips the active symlink, and suppresses all reload errors (`|| true`). `scripts/apply-theme-mode.sh` invokes that helper after other target propagation, then always prints Herdr success. Fish starts Herdr from `DreamcoderShell/.config/fish/config.fish` for interactive sessions. This creates a clear ownership and truthfulness gap: installation/repair cannot provision managed variants, and mode switching can claim success without validation or reload success.

## Theme engine architecture

Canonical modes and tokens are in `themes/dreamcoder/tokens.json`, with generated token constants in `src/dreamcoder_theme/palette_tokens.py`. `palette.py` loads variants, applies optional adaptive wallpaper behavior, and provides contrast guards. Renderer functions follow the simple `*_content(palette: dict) -> str` convention and are exported through `src/dreamcoder_theme/renderers.py`.

`sync.py` has two paths:

1. `sync_active_targets()` writes active external targets through `ThemePaths` and writer helpers.
2. `sync_repo_snippets()` produces deterministic dark/light repository variants through `VARIANT_REGISTRY`, with selected active files.

A Herdr renderer should follow the existing leaf-renderer convention, derive every value from the supplied canonical palette, be deterministic with a trailing newline, and be exported from the hub. Herdr paths need explicit `ThemePaths` entries and a registry entry for dark/light variants. The active external path should be handled as an activation selector, not silently overwritten through a stale symlink.

The Pi renderer is the closest schema-aware precedent: it uses a version/schema constant and deterministic JSON output. Herdr differs because no equivalent schema URL or validator is currently established.

## Installer, switching, and reload design implications

The safe integration boundary should separate:

- repository-generated `config.dark.toml` and `config.light.toml` variants;
- external installation ownership under `~/.config/herdr`, with conflict classification/backup consistent with installer conventions;
- an atomic active-selector update for `config.toml`;
- runtime validation before activation;
- process detection and `herdr server reload-config` only when supported and observable;
- rollback and truthful status propagation into `apply-theme-mode.sh`.

The existing installer conflict model classifies missing, repository-managed, external-symlink, and non-symlink conflicts, and creates backup manifests before install/repair. Herdr should use that model rather than taking ownership of an unrelated existing file. The active selector must not be reported as applied when variant validation or reload fails. Missing Herdr should be a clear skipped/not-installed result, while invalid config and reload failure should be actionable failures and should not be swallowed.

Automatic scheduling already routes through `theme-auto.sh` to `apply-theme-mode.sh`; explicit mode switching and automatic mode selection should converge on the same Herdr helper and result semantics. Fish startup needs no change unless runtime evidence shows a required environment/config-path handoff.

## Testability and evidence plan

Existing tests cover renderer export completeness, output consistency for both modes, sync orchestration with mocked writers/renderers, and installer planning/conflict behavior. A safe implementation can extend these seams without requiring a live Herdr process for unit tests:

- renderer tests: exact supported fields, dark/light token mapping, deterministic TOML/newline output, and rejection/fail-closed behavior for unsupported runtime profiles;
- sync tests: Herdr renderer registration, variant naming, active path, and changed-result reporting;
- installer tests: missing, managed, external, and conflicting Herdr paths plus backup/repair planning;
- shell tests or isolated HOME fixtures: mode validation, atomic selector switching, missing executable, invalid variant, reload success/failure, rollback, and truthful aggregate exit status;
- integration checks: both directions of switching, fresh install/repair, automatic scheduling, and observable reload only after runtime contract verification.

The project test command is `python -m pytest tests/ -v`; coverage and theme-health commands are documented in `openspec/project.md` and the loaded theme skills. ShellCheck/Ruff/mypy remain applicable. No runtime or repository configuration was edited during exploration.

## Decisions and open risks for proposal

- Treat Herdr as an intended first-class target, while preserving the separate `repair-dreamcoder-theme-rollout` artifacts unchanged.
- Do not emit `window-title` or `tab-title`; neither is supported by evidence.
- Do not infer palette keys from onboarding state or from the purple appearance.
- Resolve the remaining contract gap before implementation: obtain authoritative 0.7.3 schema/field evidence, a safe validation method, and observable reload behavior. If those cannot be established, the implementation must fail closed rather than introduce speculative TOML.
- Keep the first slice bounded around real Light/Dark generation, ownership, activation, and test coverage; avoid unrelated Herdr UX or unsupported settings.
