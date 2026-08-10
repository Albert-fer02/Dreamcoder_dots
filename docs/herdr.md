# Herdr Integration

> Version-bound Herdr compatibility contracts, repository-owned generated
> variants, and deployment profile settings. Live configuration is never part of
> this repository.

## Supported runtime contracts

Herdr integration is gated by complete, version-bound evidence. A profile is
usable only when every asserted behavior is present and unambiguous. Detection
matches the exact installed version; an absent, upgraded, downgraded, or
incompletely profiled binary fails closed without modifying any Herdr
configuration.

| Profile | Version | Validation | Reload | Config path | Notes |
| --- | --- | --- | --- | --- | --- |
| `herdr-0.7.3` | 0.7.3 | `herdr config check` | `herdr server reload-config` | `~/.config/herdr/config.toml` | Pre-existing supported profile |
| `herdr-0.8.0` | 0.8.0 | `herdr config check` | `herdr server reload-config` | `~/.config/herdr/config.toml` (overridable by `HERDR_CONFIG_PATH`) | Added; see evidence below |

### Herdr 0.8.0 installed-binary evidence

Observed exactly from the installed executable, with nothing beyond it asserted:

- Executable: `herdr`, version `0.8.0`
- Binary SHA-256:
  `b872ea7e40fa2cb17e857ac9b62b1bf26db7b403c622f5d2f3f5b35f6e9acd28`
- Default config confirms `[ui] pane_scrollbars = false`
- Config validation: `herdr config check`
- Reload command: `herdr server reload-config`
- Config path: `~/.config/herdr/config.toml`, overridable via `HERDR_CONFIG_PATH`

The 0.8.0 variant reuses the previously evidenced theme and keys structure and
adds only the observed 0.8.0 deltas: `[ui] pane_scrollbars = false` and the
binary identity above.

## Generated repository variants

Versioned variants are generated from the Dreamcoder canonical tokens
(`DreamcoderThemes/dreamcoder/tokens.json`) by the theme sync and checked in so
drift is detectable:

```text
DreamcoderHerdr/.config/herdr/dreamcoder/
  0.7.3/config.dark.toml
  0.7.3/config.light.toml
  0.8.0/config.dark.toml
  0.8.0/config.light.toml
```

- Each variant carries the header `# Managed by Dreamcoder; repository variant only.`
- Light renders Dreamcoder Light; dark renders Dreamcoder dark.
- The 0.8.0 variants include `pane_scrollbars = false`.
- Active/live configuration (`~/.config/herdr/config.toml`, or whatever
  `HERDR_CONFIG_PATH` points to) stays out of git. The repository only ever
  ships static, versioned variants.

## Deployment profiles

`DreamcoderProfiles/deploy/` holds repository-safe deployment profiles:

- `desktop-arch.json` — desktop Arch Linux deployment; supports the full
  day/night cycle via systemd timers. Herdr `[ui] pane_scrollbars` follows the
  Herdr default (`false`).
- `mobile-termux.json` — mobile Termux/Moshi deployment; selects Dreamcoder
  Light and disables Herdr pane scrollbars for narrow screens. It contains
  rendering settings only — never a device address, username, key, or host
  runtime state.

## Verification

```bash
python3 scripts/verify-repo-sync.py
```

This checks that every generated variant matches the renderer byte-for-byte,
that deployment profiles validate against their schema, that the mobile profile
selects Light with pane scrollbars disabled, that the source manifest is
present, and that no sensitive material exists in the synchronization surface.
When `herdr` is installed, the verifier additionally runs `herdr config check`
against a temporary copy of the 0.8.0 light variant using `HERDR_CONFIG_PATH`
(never the live configuration). When `herdr` is absent, that step is skipped
safely.

## Live switching

The existing `scripts/herdr-theme-switch.sh` symlinks a repository variant into
the live `~/.config/herdr/config.toml` and reloads a running server. That
switcher operates on live user configuration by design and is not part of the
repository-owned sync surface; operators can alternatively point
`HERDR_CONFIG_PATH` at any checked-in versioned variant for validation or
temporary use.
