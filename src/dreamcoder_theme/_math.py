"""Pure color math functions — zero I/O, zero side effects.

Domain layer of the Dreamcoder theme engine. Imports only stdlib math types.
"""

from __future__ import annotations


def hex_to_rgb(value: str) -> tuple[int, int, int]:
    """Convert hex color string to RGB tuple."""
    value = value.lstrip("#")
    return int(value[0:2], 16), int(value[2:4], 16), int(value[4:6], 16)


def rgb_to_hex(rgb: tuple[int, int, int]) -> str:
    """Convert RGB tuple to hex color string."""
    return "#" + "".join(f"{max(0, min(255, part)):02x}" for part in rgb)


def mix(left: str, right: str, amount: float) -> str:
    """Linear interpolation between two hex colors."""
    a = hex_to_rgb(left)
    b = hex_to_rgb(right)
    return rgb_to_hex(tuple(round(x + (y - x) * amount) for x, y in zip(a, b)))  # type: ignore[arg-type]


def rel_luminance(value: str) -> float:
    """WCAG 2.1 relative luminance of a hex color."""
    r, g, b = hex_to_rgb(value)
    sr, sg, sb = r / 255, g / 255, b / 255
    lr = sr / 12.92 if sr <= 0.03928 else ((sr + 0.055) / 1.055) ** 2.4
    lg = sg / 12.92 if sg <= 0.03928 else ((sg + 0.055) / 1.055) ** 2.4
    lb = sb / 12.92 if sb <= 0.03928 else ((sb + 0.055) / 1.055) ** 2.4
    return 0.2126 * lr + 0.7152 * lg + 0.0722 * lb


def contrast(fg: str, bg: str) -> float:
    """WCAG 2.1 contrast ratio between two hex colors."""
    a, b = sorted((rel_luminance(fg), rel_luminance(bg)), reverse=True)
    return (a + 0.05) / (b + 0.05)


def guard(color: str, background: str, mode_name: str, minimum: float = 4.5) -> str:
    """Adjust color toward white (dark mode) or black (light mode) until
    it meets the minimum contrast ratio against the background."""
    target = "#ffffff" if mode_name == "dark" else "#000000"
    safe = color
    for _ in range(12):
        if contrast(safe, background) >= minimum:
            return safe
        safe = mix(safe, target, 0.18)
    return safe


def compute_on_color(
    background: str,
    mode_name: str,
    *,
    light_candidate: str | None = None,
    dark_candidate: str | None = None,
    minimum: float = 4.5,
) -> str:
    """Pick readable foreground (text) on a filled surface."""
    candidates: list[str]
    if mode_name == "dark":
        candidates = [c for c in (dark_candidate, "#100f0d", "#000000") if c]
    else:
        candidates = [c for c in (light_candidate, "#fff7ea", "#ffffff") if c]
    for candidate in candidates:
        if contrast(candidate, background) >= minimum:
            return candidate
    return guard(candidates[-1], background, mode_name, minimum=minimum)


def surface_guard(
    color: str,
    background: str,
    mode_name: str,
    minimum: float = 1.05,
    maximum: float = 2.4,
) -> str:
    """Keep color within a contrast range against background for UI surfaces."""
    if contrast(color, background) < minimum:
        target = "#ffffff" if mode_name == "dark" else "#000000"
        safe = color
        for _ in range(12):
            safe = mix(safe, target, 0.08)
            if contrast(safe, background) >= minimum:
                return safe
        return safe
    if contrast(color, background) > maximum:
        safe = color
        for _ in range(12):
            safe = mix(safe, background, 0.12)
            if contrast(safe, background) <= maximum:
                return safe
        return safe
    return color
