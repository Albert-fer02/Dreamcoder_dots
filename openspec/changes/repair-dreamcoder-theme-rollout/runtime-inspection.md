# Herdr Runtime Inspection

## Gate Decision

- **state:** pending
- **inspection date:** 2026-07-16 (UTC)
- **scope:** local, read-only runtime inspection; no external configuration was changed.
- **decision:** Do not add Herdr syntax, renderer output, generated variants, installer ownership, activation, or reload implementation.

`pending` is required because the reported parser errors could not be attributed to the running Herdr instance and an authoritative, version-tied schema/validator contract was not available.

## Sanitized Runtime Identity

| Fact               | Evidence                                                                                                       |
| ------------------ | -------------------------------------------------------------------------------------------------------------- |
| Executable         | `herdr`, resolved to a user-local executable path (path redacted)                                              |
| Digest             | SHA-256 `043ef43ecbabda28465dcff1eec3184518150d567b8b8f20cda9c6c88770641d`                                     |
| Package provenance | Unavailable from the local package manager query                                                               |
| Installed version  | `herdr 0.7.3`                                                                                                  |
| Platform           | Linux `7.1.3-zen1-3-zen`, `x86_64`                                                                             |
| Upstream identity  | CLI help identifies it as “terminal workspace manager for AI coding agents” and references `https://herdr.dev` |
| Running process    | A process named `herdr` was present at inspection time                                                         |

## Config and Error Attribution

| Item                | Sanitized observation                                                                                                              |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Default config path | `<HOME>/.config/herdr/config.toml`, reported by `herdr --help`                                                                     |
| Active selector     | Present symlink; its target basename was `config.light.toml`                                                                       |
| Dark candidate      | `<HOME>/.config/herdr/config.dark.toml`: regular file, UID `1000`, mode `0644`                                                     |
| Light candidate     | `<HOME>/.config/herdr/config.light.toml`: regular file, UID `1000`, mode `0644`                                                    |
| Active candidate    | Symlink, UID `1000`; link-mode metadata is not a permission contract                                                               |
| Field scan          | `window-title` and `tab-title` were absent from active, Dark, and Light candidates; no config contents or values were recorded     |
| Log scan            | The three documented local Herdr logs contained none of `window-title`, `tab-title`, or `unknown field` at inspection time         |
| Error consumer      | **Unverified.** No reproduced parser diagnostic or runtime log attributed the reported errors to Herdr or to a parsed config file. |

Herdr help documents that `HERDR_CONFIG_PATH` can override the default path. Environment values were intentionally not inspected, so the actual parsed path and selector semantics remain unverified.

## Version-Tied Contract Evidence

| Contract question     | Evidence and result                                                                                                                                                              |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Schema/help           | `herdr --help` for `0.7.3` documents the CLI, default config location, and override variable; `herdr config --help` lists only `reset-keys` and supplies no schema or validator. |
| Validator             | No authoritative validation subcommand or version-tied schema was discovered. No candidate was reloaded or started during this read-only inspection.                             |
| Reload/restart        | `herdr server reload-config` is advertised by the `0.7.3` help and accepts no documented options. Its success/failure exit semantics were not documented or exercised.           |
| Process detection     | `pgrep -x herdr` detected a running process by executable name only; it does not prove which config that process parsed.                                                         |
| Active-file selection | Help establishes a default path plus an environment override. The observed symlink target is an external-file observation, not authoritative runtime selection semantics.        |

## Field Dispositions

| Field          | Disposition                                                         |
| -------------- | ------------------------------------------------------------------- |
| `window-title` | No supported representation established; do not emit or replace it. |
| `tab-title`    | No supported representation established; do not emit or replace it. |

## Compatibility Bounds and Next Step

This record applies only to the observed `herdr 0.7.3` executable digest on the recorded Linux platform. It does **not** establish a supported config schema, validator, actual parsed file, or reload result. The chain is blocked pending a reproducible sanitized parser diagnostic that proves the consumer and config path, plus authoritative `0.7.3` schema/validation and reload-exit evidence. External configuration remains untouched.
