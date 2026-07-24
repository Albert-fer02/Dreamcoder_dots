"""Pure theme mode detection — zero I/O.

Determines light/dark/dusk from token data or file content strings.
"""

from __future__ import annotations

DARK_MARKERS = ("dreamcoder dark", "ember noir", "anthracite steel")
LIGHT_MARKERS = ("dreamcoder light", "cocoa cream")


def from_tokens(tokens: dict) -> str:
    """Detect mode from a tokens dictionary. Returns 'light', 'dark', or 'dusk'."""
    active = tokens.get("active_mode", "")
    if active in ("light", "dark", "dusk"):
        return active
    return "light"


def from_file_content(text: str) -> str:
    """Detect mode by scanning file content for known theme markers."""
    lowered = text.lower()
    for marker in DARK_MARKERS:
        if marker in lowered:
            return "dark"
    for marker in LIGHT_MARKERS:
        if marker in lowered:
            return "light"
    return "unknown"
