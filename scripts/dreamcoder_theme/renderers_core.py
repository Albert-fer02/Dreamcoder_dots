"""Shared renderer helpers."""

from __future__ import annotations

from .palette import ANSI_KEYS, guard, resolve_color

def ansi(palette: dict[str, str]) -> list[str]:
    mode_name = "dark" if palette["details"] == "darker" else "light"
    safe = []
    for key in ANSI_KEYS:
        color = resolve_color(palette, key)
        safe.append(guard(color, palette["bg"], mode_name))
    return safe
