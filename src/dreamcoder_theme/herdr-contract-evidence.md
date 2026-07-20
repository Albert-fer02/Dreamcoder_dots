# Herdr 0.7.3 Runtime Contract Evidence

## Supported profile

`herdr-0.7.3` is the only enabled production profile. It is bound to local
`herdr 0.7.3`, binary SHA-256
`043ef43ecbabda28465dcff1eec3184518150d567b8b8f20cda9c6c88770641d`, and the
official v0.7.3 source tag object `d0111c9f9022e0ec26d8f03236a91b026b567d45`,
which points to source commit `299dd4163a96381ec2d8e5bde13d7ba6d6432373`.

The official version-bound configuration reference documents `[theme]` keys
`name`, `auto_switch`, `dark_name`, and `light_name`, plus exactly these
`[theme.custom]` keys:

`accent`, `panel_bg`, `surface0`, `surface1`, `surface_dim`, `overlay0`,
`overlay1`, `text`, `subtext0`, `mauve`, `green`, `yellow`, `red`, `blue`,
`teal`, and `peach`.

Custom colors accept hex values, so repository variants serialize canonical
Dreamcoder tokens as `#RRGGBB` strings. `window-title`, `tab-title`, and every
other undocumented custom field are excluded.

## Static repository variants

`theme.name` selects a built-in base theme and defaults to `catppuccin`.
`theme.auto_switch` defaults to `false`; `theme.dark_name` and
`theme.light_name` are optional and apply only to host-appearance switching.

The managed static Dark and Light repository variants emit only
`name = "catppuccin"` and the allow-listed custom overrides. They deliberately
omit `auto_switch`, `dark_name`, and `light_name`; no labels are invented. The
variants are generated under
`DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/` and are never selected or
written to the user's active configuration by theme synchronization.

## Isolated validation and reload evidence

An isolated temporary environment using `HERDR_CONFIG_PATH`, XDG directories,
and `HERDR_SOCKET_PATH` accepted a valid candidate configuration.
`herdr server reload-config` reported applied with no diagnostics and
`restart_needed: false`; restoring a valid configuration also succeeded.

Unknown fields are silently accepted by this runtime. Reload is therefore not
an exhaustive schema validator. The renderer emits the documented allow-list
only, and later activation work must preserve this limitation.

## Fail-closed boundary

Unknown, malformed, or non-0.7.3 version output remains
`unsupported-contract`; an absent executable remains `skipped-not-installed`.
No user-owned configuration is read, selected, or mutated by this repository
variant slice.
