# Ghostty Runtime Inspection

## Gate Decision

- **state:** pending
- **inspection date:** 2026-07-16 (UTC)
- **scope:** local, read-only inspection and an isolated disposable fixture; no active Ghostty configuration was changed.
- **decision:** Do not edit `window-title`, `tab-title`, renderer output, generated themes, installation, synchronization, or activation behavior.

The screenshot attribution and the default validator establish Ghostty as the error producer, but the complete startup file-open/include graph cannot be authoritatively captured on this host. The locally advertised CLI exposes no parsed-path diagnostic, and the available Linux file-open tracer is unavailable. Therefore the evidence gate remains `pending`.

## Sanitized Runtime Identity

| Fact                        | Evidence                                                                                                                                                                                 |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Executable                  | `/usr/bin/ghostty`, resolved from `command -v`                                                                                                                                           |
| Digest                      | SHA-256 `d943cc1d6c6d24de8964b689bb7de6c827731560b37122e649f75d9e23b57580`                                                                                                               |
| Version                     | Ghostty `1.3.1-arch2`; channel `tip`                                                                                                                                                     |
| Package provenance          | Local package query: `ghostty 1.3.1-2` owns the executable                                                                                                                               |
| Platform                    | Linux `7.1.3-zen1-3-zen`, `x86_64`; GTK runtime                                                                                                                                          |
| Local authoritative sources | `ghostty --help`; `ghostty +validate-config --help`; `ghostty +show-config --help`; `ghostty +edit-config --help`; `ghostty +show-config --default --docs` from the inspected executable |

## Parser, Source, and Ownership Evidence

| Fact                     | Sanitized observation                                                                                                                                                                                                   |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Startup diagnostic       | Default `ghostty +validate-config` exited `1` and emitted `window-title: unknown field` and `tab-title: unknown field`.                                                                                                 |
| Installed root           | The active XDG Ghostty root is a symbolic link resolving to repository-managed `DreamcoderGhostty/.config/ghostty`.                                                                                                     |
| Candidate source         | Resolved `config` is a regular file whose SHA-256 is `f2d94fc264e8ad21511f9a1c3e95b3e6829f67fd2955cb1812b64a829cacdf14`.                                                                                                |
| Exact field locations    | The resolved candidate contains `window-title` at line 49 and `tab-title` at line 50. Values are intentionally not recorded.                                                                                            |
| Ownership classification | `managed_symlink` at the installed root, resolving to the `repository_source` candidate above. This classification is provisional until the complete parsed graph is traced.                                            |
| Config-file directives   | Value-free scan found no `config-file` assignments in the candidate.                                                                                                                                                    |
| Theme directives         | Value-free scan found one `theme` assignment; its value and any resulting theme path are not recorded without a parsed-file trace.                                                                                      |
| Complete parsed graph    | **Unverified.** The advertised validator reports field errors but not opened paths. `strace` is unavailable, so the required isolated file-open trace could not run. Repository resolution is supporting evidence only. |

## Version-Tied Configuration Contract

- `+validate-config --help` advertises `--config-file` for validating a specific target file; without arguments it validates the default location.
- The default validator exit contract was observed: invalid configuration exits `1` and reports the unknown fields above.
- An isolated disposable fixture copied from the resolved managed Ghostty root retained the same candidate hash; direct `+validate-config --config-file <fixture>/config` exited `1`. Fixture contents were removed after inspection and are not persisted here.
- `+show-config --default --docs` is the authoritative schema emitted by this executable. It does **not** document `window-title` or `tab-title`.
- The same schema documents `title` as the fixed window-title setting and says it can reload at runtime. This is not a replacement decision: the intended behavior and complete parsed graph remain unproven.
- The schema documents a `theme` value with paired Light/Dark syntax (`light:<name>,dark:<name>`) selected from the current desktop theme. It also documents custom-theme search under the Ghostty configuration `themes` directory.
- `+edit-config --help` states edits do not reload automatically; supported reload paths are the application menu, a configured keybind, or restarting Ghostty. No active-process reload was exercised because Slice 1 may not mutate the active configuration.

## Field Dispositions

| Field          | Evidence-derived disposition                                                                                                                                  | Status  |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `window-title` | The inspected schema does not document this key. Do not retain, rename, or replace it until the complete parsed graph and intended title behavior are proven. | pending |
| `tab-title`    | The inspected schema does not document this key. Do not retain, rename, or replace it until the complete parsed graph and intended title behavior are proven. | pending |

## Compatibility Bounds and Slice 2 Condition

This record applies only to the inspected Ghostty `1.3.1-arch2` executable with the recorded digest on the recorded Linux/GTK platform. It establishes a validator, schema source, invalid-field diagnostic, and repository-managed candidate identity. It does not establish every file opened by Ghostty, the selected theme path, complete include precedence, or a safely exercisable activation transaction.

Slice 2 is permitted only after a sanitized file-open/parsed-path trace establishes the complete startup graph and ties each title-field disposition to that graph and the inspected schema. Until then, `window-title` and `tab-title` remain unchanged.
