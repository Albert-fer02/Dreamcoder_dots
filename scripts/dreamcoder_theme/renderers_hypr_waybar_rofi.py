"""Focused desktop shell theme renderers."""

from __future__ import annotations

import json
import re

# ---------------------------------------------------------------------------
# Dreamcoder → Material Design 3 (Matugen-compatible) color-role mapping.
# ML4W 2.13+ requires colors.lua + colors.conf with these exact tokens.
# ---------------------------------------------------------------------------


def _hex_to_rgba_ff(hex_color: str) -> str:
    """Convert #RRGGBB → rgba(RRGGBBff) for Matugen/Hyprland format."""
    return f"rgba({hex_color[1:]}ff)"


def _map_dc_to_material(c: dict[str, str]) -> dict[str, str]:
    """Map Dreamcoder palette tokens to Material Design 3 color roles."""
    h = _hex_to_rgba_ff
    return {
        # Core surfaces
        "background": h(c["bg"]),
        "surface": h(c["bg"]),
        "surface_dim": h(c["bg_soft"]),
        "surface_bright": h(c["surface0"]),
        "surface_container_lowest": h(c["surface0"]),
        "surface_container_low": h(c["surface0"]),
        "surface_container": h(c["surface1"]),
        "surface_container_high": h(c["surface1"]),
        "surface_container_highest": h(c["surface2"]),
        "surface_variant": h(c["surface1"]),
        "surface_tint": h(c["accent"]),
        # On-colors
        "on_background": h(c["text"]),
        "on_surface": h(c["text"]),
        "on_surface_variant": h(c["muted"]),
        # Primary
        "primary": h(c["accent"]),
        "on_primary": h(c["bg"]),
        "primary_container": h(c["surface1"]),
        "on_primary_container": h(c["text"]),
        "primary_fixed": h(c["accent"]),
        "primary_fixed_dim": h(c["accent_2"]),
        "on_primary_fixed": h(c["bg"]),
        "on_primary_fixed_variant": h(c["accent"]),
        "inverse_primary": h(c["accent"]),
        # Secondary
        "secondary": h(c["accent_2"]),
        "on_secondary": h(c["bg"]),
        "secondary_container": h(c["surface1"]),
        "on_secondary_container": h(c["text"]),
        "secondary_fixed": h(c["accent_2"]),
        "secondary_fixed_dim": h(c["accent_2"]),
        "on_secondary_fixed": h(c["bg"]),
        "on_secondary_fixed_variant": h(c["accent_2"]),
        # Tertiary
        "tertiary": h(c["diagnostic"]),
        "on_tertiary": h(c["bg"]),
        "tertiary_container": h(c["surface0"]),
        "on_tertiary_container": h(c["text"]),
        "tertiary_fixed": h(c["diagnostic"]),
        "tertiary_fixed_dim": h(c["diagnostic"]),
        "on_tertiary_fixed": h(c["bg"]),
        "on_tertiary_fixed_variant": h(c["focus"]),
        # Error
        "error": h(c["error"]),
        "on_error": h(c["bg"]),
        "error_container": h(c["surface0"]),
        "on_error_container": h(c["text"]),
        # Outline
        "outline": h(c["border"]),
        "outline_variant": h(c["border_ui"]),
        # Fixed
        "shadow": "rgba(000000ff)",
        "scrim": "rgba(000000ff)",
        "source_color": h(c["accent"]),
        # Inverse
        "inverse_on_surface": h(c["surface0"]),
        "inverse_surface": h(c["text"]),
    }


def _rgba_to_argb(value: str, default_alpha: str = "ff") -> str:
    """Convert rgba(r, g, b, a) to rgba(RRGGBBAA) for Hyprland."""
    match = re.match(
        r"rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*([01]?\.?\d*)\s*\)",
        value,
    )
    if not match:
        return value
    r, g, b, a = match.group(1), match.group(2), match.group(3), float(match.group(4))
    a_hex = f"{round(a * 255):02x}"
    return f"rgba({r.zfill(2)}{g.zfill(2)}{b.zfill(2)}{a_hex})"


def hypr_content(c: dict[str, str]) -> str:
    inactive = _rgba_to_argb(c.get("inactive_border", "rgba(89, 77, 70, 0.78)"))
    return f"""# Dreamcoder color layer for Hyprland.
# Import after ML4W/Gentleman defaults; this changes colors only.

general {{
    col.active_border = rgba({c["accent"][1:]}ff) rgba({c["diagnostic"][1:]}ff) 45deg
    col.inactive_border = {inactive}
}}

misc {{
    background_color = rgba({c["bg"][1:]}ff)
}}
"""


def waybar_content(c: dict[str, str]) -> str:
    return f"""/* Dreamcoder color layer for Waybar. */
@define-color bg {c["bg"]};
@define-color bg-soft {c["bg_soft"]};
@define-color surface {c["surface0"]};
@define-color text {c["text"]};
@define-color muted {c["muted"]};
@define-color border {c["border"]};
@define-color border-ui {c["border_ui"]};
@define-color focus {c["focus"]};
@define-color accent {c["accent"]};
@define-color accent-2 {c["accent_2"]};
@define-color diagnostic {c["diagnostic"]};
@define-color error {c["error"]};
@define-color success {c["sage"]};
@define-color warning {c["warning"]};

window#waybar {{
  background: {c["panel_rgba"]};
  color: @text;
  border-bottom: 1px solid alpha(@accent, 0.26);
}}

#workspaces button {{
  color: @muted;
  background: transparent;
  border: 1px solid transparent;
}}

#workspaces button.active {{
  color: @accent;
  background: {c["active_rgba"]};
  border-color: alpha(@focus, 0.82);
}}

#clock,
#battery,
#network,
#pulseaudio,
#cpu,
#memory,
#tray {{
  background: {c["module_rgba"]};
  color: @text;
  border: 1px solid alpha(@border-ui, 0.78);
}}

#battery.warning {{ color: @warning; }}
#battery.critical {{ color: @error; }}
#network.disconnected {{ color: @error; }}
"""


def rofi_content(c: dict[str, str]) -> str:
    return f"""/* Dreamcoder color layer for Rofi. */
* {{
  background: {c["panel_rgba"]};
  background-alt: {c["surface0"]};
  foreground: {c["text"]};
  muted: {c["muted"]};
  selected: {c["active_rgba"]};
  active: {c["accent"]};
  border-ui: {c["border_ui"]};
  focus: {c["focus"]};
  urgent: {c["error"]};
  border-color: {c["border_ui"]};
}}

window {{
  background-color: @background;
  border: 1px;
  border-color: @border-ui;
  border-radius: 18px;
}}

entry {{
  background-color: @selected;
  text-color: @foreground;
  border: 1px;
  border-color: @focus;
  border-radius: 12px;
}}

element selected {{
  background-color: @selected;
  text-color: @foreground;
  border: 0 0 0 3px;
  border-color: @focus;
}}

element-text {{ text-color: @muted; }}
element selected element-text {{ text-color: @foreground; }}
"""


def hypr_colors_lua_content(c: dict[str, str]) -> str:
    """Generate colors.lua in Matugen/Material-You format for ML4W Hyprland."""
    m = _map_dc_to_material(c)
    lines = []
    for key in sorted(m.keys()):
        lines.append(f'{key} = "{m[key]}"')
    return "\n".join(lines) + "\n"


def hypr_colors_conf_content(c: dict[str, str]) -> str:
    """Generate colors.conf in Matugen/Material-You format for ML4W Hyprland."""
    m = _map_dc_to_material(c)
    lines = []
    for key in sorted(m.keys()):
        lines.append(f"${key} = {m[key]}")
    return "\n".join(lines) + "\n"
