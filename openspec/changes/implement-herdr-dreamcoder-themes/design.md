# Design: Minimal Herdr 0.7.3 Theme Activation

## Overview

This change has two narrowly separated responsibilities:

1. Deterministically render exactly two repository-owned Herdr configurations: Dreamcoder Dark and Dreamcoder Light.
2. Explicitly install one selected complete configuration into the resolved Herdr target through a small transactional activation operation.

```text
canonical dark/light palettes
  -> Herdr renderer
     -> [theme] + [theme.custom]              Dreamcoder-owned
     -> [ui] + [keys]                         upstream-canonical constants
  -> versioned static config.{dark,light}.toml
  -> explicit activation(mode, reload_requested)
     -> exact version gate
     -> environment-derived target
     -> backup (when target exists)
     -> sibling staging file
     -> atomic replacement
     -> optional documented reload
     -> restore on committed-write/reload failure
     -> structured result
```

There is no migration, merge, ownership database, scheduler, mode inference, process discovery, or cross-target orchestration. The implementation is intentionally sized as one reviewable first slice below 400 authored lines, including focused tests.

## Decisions

### 1. Static configuration ownership

`herdr_content(profile, mode, palette)` remains a pure renderer and accepts only `dark` or `light`.

The complete TOML document is emitted in a fixed order:

1. `[theme]`
2. `[theme.custom]`
3. `[ui]`
4. `[keys]`

Dreamcoder palette values may affect only `[theme]` and `[theme.custom]`. `[ui]` and `[keys]` are renderer constants copied from the approved upstream configuration and are not represented as palette tokens:

```toml
[ui]
accent = "#6FA0AF"

[keys]
prefix = "ctrl+a"
previous_agent = "prefix+alt+k"
next_agent = "prefix+alt+j"
focus_agent = "prefix+ctrl+1..9"
```

The renderer preserves deterministic UTF-8 output, LF line endings, fixed field ordering, and one trailing newline. Repository sync writes only:

- `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.dark.toml`
- `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.light.toml`

No `dusk`, adaptive, active, or third Herdr variant is generated.

### 2. Exact runtime gate

Activation invokes `herdr --version` without a shell. It proceeds only when successful stdout, after removing one trailing line ending, equals exactly `herdr 0.7.3`. Missing executables, non-zero exit, timeout, extra text, malformed output, and every other version are precondition failures.

This check occurs before directory creation, backup creation, temporary-file creation, or target mutation. The existing broad compatibility-profile concept is not required by this approved slice; the operational contract is the exact version string plus the documented path variable and reload command.

### 3. Explicit mode and source selection

The activation API accepts only `mode: Literal["dark", "light"]`. It maps that value directly to the corresponding checked-in 0.7.3 static variant; callers cannot provide an arbitrary source path.

Before filesystem mutation, activation reads the complete source bytes and validates the TOML shape needed by this change:

- top-level sections are the expected `theme`, `ui`, and `keys` sections;
- `theme.custom` exists;
- `[ui]` and `[keys]` equal the canonical constants exactly;
- the source is a regular file and the requested mode maps to the expected versioned filename.

This is source validation, not a general Herdr schema validator or configuration merge facility.

### 4. Runtime target resolution

A pure `resolve_herdr_target(env)` function applies this precedence:

1. A non-empty `HERDR_CONFIG_PATH` value.
2. `${XDG_CONFIG_HOME}/herdr/config.toml` when `XDG_CONFIG_HOME` is non-empty.
3. `${HOME}/.config/herdr/config.toml` when `XDG_CONFIG_HOME` is unset.

Resolved environment paths must be absolute and non-root. Empty variables required by the selected branch, relative paths, embedded NULs, an existing directory at the target, a target symlink, or a symlinked existing parent component fail closed. Values are not shell-expanded, and no username or absolute home path is embedded in code.

For an absent XDG-derived target, the Herdr parent directory may be created after all non-filesystem preconditions pass. An override requires its parent to exist so activation does not create an arbitrary caller-selected tree. Directories created for the XDG target are removed on failure only when they remain empty.

### 5. Transaction boundaries and atomicity

The only writable paths are:

- the single resolved target;
- a unique sibling backup when the target already exists;
- a unique sibling staging file;
- the XDG-derived Herdr parent directory when it does not exist.

Existing targets must be regular files and are never followed through symlinks. Backup and staging files are created in the target directory with exclusive creation and restrictive permissions. Same-directory placement guarantees that `os.replace` does not cross filesystems.

Activation uses this sequence:

1. Validate mode, exact runtime version, source variant, and resolved path.
2. Read and retain target identity and bytes when it exists.
3. Create a unique sibling backup with exclusive creation, copy the prior bytes, flush, and `fsync`; retain this backup after success.
4. Create a unique sibling staging file, write the complete selected bytes, flush, and `fsync`.
5. Re-check that the target identity has not changed since step 2; otherwise delete the staging file and fail without replacing the target.
6. Commit with `os.replace(staging, target)` and `fsync` the parent directory.
7. If explicitly applicable, invoke the documented reload command.

A failure before `os.replace` leaves the original target unchanged. If failure occurs after replacement may have committed, restoration is mandatory:

- for a previously existing target, copy the retained backup into a new sibling staging file and atomically replace the target;
- for a previously absent target, remove only the newly created target after confirming it is still the file installed by this operation;
- flush the parent directory after restoration.

Backup files are never consumed during restoration, so their recovery evidence remains available. Temporary files are removed on best effort. No other file is repaired or changed.

### 6. Reload applicability

Applicability is explicit invocation context, represented by `reload_requested: bool` (and a CLI `--reload` flag if a module CLI is exposed). The activation operation does not inspect process tables, sockets, PID files, or server state.

When `reload_requested` is false, activation reports a successful file update with reload status `not-requested`. When true, and only after atomic replacement succeeds, it invokes exactly:

```text
herdr server reload-config
```

The command is executed without a shell and with a bounded timeout. Zero exit is success; non-zero exit, launch failure, or timeout is reload failure. A failed attempted reload triggers filesystem restoration. No alternate signal, retry loop, second reload, or undocumented server inference is introduced, and the result does not claim live-runtime restoration.

## Operation Contract

The Python boundary is conceptually:

```python
activate_herdr(mode: Literal["dark", "light"], *, reload_requested: bool) -> ActivationResult
```

`ActivationResult` is a frozen data object suitable for direct CLI serialization:

```text
status: applied | precondition-failed | backup-failed | write-failed |
        reload-failed-restored | restore-failed
stage: mode | version | source | path | backup | stage-write | replace |
       reload | restore | complete
mode: dark | light | null
reload: not-requested | succeeded | failed
restoration: not-required | succeeded | failed
backup_path: path | null
target: path | null
message: actionable summary without file contents
```

Only `applied` is successful. `applied` covers both `reload=succeeded` and `reload=not-requested`; callers must not infer a live reload from the former case. All other statuses are non-zero failures.

`write-failed` means the prior state is proven unchanged or restored; `reload-failed-restored` means the attempted reload failed but the file state was restored. Any required restoration that cannot be proven returns `restore-failed`, includes the retained backup path when one exists, and preserves the original failure stage in the message. Errors never include configuration contents or environment dumps.

## Proposed File Changes

The implementation slice should remain limited to these responsibilities:

- `src/dreamcoder_theme/renderers_herdr.py`: append canonical `[ui]` and `[keys]` constants to the existing Light/Dark renderer.
- `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.dark.toml`: regenerate the complete Dark variant.
- `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.light.toml`: regenerate the complete Light variant.
- `src/dreamcoder_theme/herdr_activation.py` (new): target resolution, exact version gate, source validation, transaction, optional documented reload, restoration, and result model.
- `tests/test_herdr_theme_generation.py`: canonical-section and two-variant assertions.
- `tests/test_herdr_activation.py` (new): focused activation transaction tests.

`sync.py` should continue repository-only Herdr generation and must not activate a live target. No change is designed for `settings.py`, general writers, installer/repair systems, shell/Fish scripts, schedulers, automatic mode selection, Hyprland, Ghostty, other targets, or palette tokens. If a thin CLI is needed, keep it inside `herdr_activation.py` rather than adding a framework or packaging entry point.

## Focused Test Matrix

All activation tests use temporary directories and a fake `herdr` executable; no test reads or writes the user's Herdr directory.

| Area               | Cases                                                                | Required assertion                                                                                               |
| ------------------ | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| Rendering          | Light and Dark                                                       | Canonical `[ui]`/`[keys]` are byte-identical; palette differences are confined to `[theme]` and `[theme.custom]` |
| Rendering boundary | `dusk` and arbitrary mode                                            | Rejected; no third artifact                                                                                      |
| Version            | exact 0.7.3                                                          | Mutation may proceed                                                                                             |
| Version            | missing, non-zero, timeout, malformed, 0.7.2/0.7.4, extra output     | Failure before backup/temp/target mutation                                                                       |
| Path precedence    | override set                                                         | Override wins                                                                                                    |
| Path fallback      | XDG set; XDG unset with HOME                                         | Expected absolute Herdr target                                                                                   |
| Path safety        | empty/relative/root path, target directory/symlink, symlinked parent | Failure before backup or replacement                                                                             |
| Source safety      | missing, non-regular, malformed, wrong canonical sections            | Failure before target mutation                                                                                   |
| Existing target    | successful activation                                                | Distinct byte-exact backup precedes atomic replacement and remains afterward                                     |
| Absent target      | successful activation                                                | Atomic creation; no backup claimed                                                                               |
| Backup             | exclusive-create/copy/fsync failure                                  | Original bytes unchanged; no reload                                                                              |
| Stage/write        | write/fsync/replace failure before commit                            | Original unchanged; staging cleaned; no reload                                                                   |
| Concurrency        | target identity changes before replace                               | Conflict reported as write failure; external bytes preserved                                                     |
| Reload             | not requested                                                        | No command; applied with `reload=not-requested`                                                                  |
| Reload             | requested and successful                                             | Exact documented argv occurs after replacement                                                                   |
| Reload rollback    | non-zero, timeout, launch failure                                    | Previous file restored atomically, or newly created target safely removed; failed result                         |
| Restore failure    | injected restore replace/fsync/unlink failure                        | `restore-failed`; backup path surfaced when available; no collateral writes                                      |
| Scope              | every case                                                           | Writes are confined to target, sibling backup/temp, and allowed XDG parent                                       |

Focused execution:

```bash
python -m pytest tests/test_herdr_theme_generation.py tests/test_herdr_activation.py -v
ruff check src/dreamcoder_theme/renderers_herdr.py src/dreamcoder_theme/herdr_activation.py tests/test_herdr_theme_generation.py tests/test_herdr_activation.py
```

Existing project-wide tests remain regression evidence, but this slice does not authorize unrelated fixes.

## Rollout and Rollback

1. Land renderer constants and regenerated static variants with exact artifact tests.
2. Land the activation module disabled from automatic theme switching; users invoke it explicitly with `dark` or `light` and opt into reload through `--reload`.
3. Verify both update-only and update-plus-reload paths against the evidenced Herdr 0.7.3 command contract.

Repository rollback reverts only the files listed above. Runtime rollback uses the retained sibling backup for an existing target; for a target created by the failed transaction, it removes only that proven-created file. Automatic integration, backup cleanup policy, support for another Herdr version, migration, merging, and additional runtime behavior require separate approved changes.

## Implementation Budget

The first slice is constrained to fewer than 400 authored changed lines. The target allocation is approximately:

- renderer and generated variants: 35 lines;
- activation implementation and small CLI: 170 lines;
- focused tests: 170 lines;
- total target: about 375 authored lines.

If the safety contract cannot fit this budget, reduce convenience surface or split out CLI presentation; do not add frameworks or weaken version, backup, atomicity, reload, or restoration guarantees.
