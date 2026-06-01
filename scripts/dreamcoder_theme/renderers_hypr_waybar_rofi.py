"""Focused desktop shell theme renderers."""

from __future__ import annotations

import json


def hypr_content(c: dict[str, str]) -> str:
    return f"""# Dreamcoder color layer for Hyprland.
# Import after ML4W/Gentleman defaults; this changes colors only.

general {{
    col.active_border = rgba({c['accent'][1:]}ff) rgba({c['diagnostic'][1:]}ff) 45deg
    col.inactive_border = {c['inactive_border']}
}}

misc {{
    background_color = rgba({c['bg'][1:]}ff)
}}
"""


def waybar_content(c: dict[str, str]) -> str:
    return f"""/* Dreamcoder color layer for Waybar. */
@define-color bg {c['bg']};
@define-color bg-soft {c['bg_soft']};
@define-color surface {c['surface0']};
@define-color text {c['text']};
@define-color muted {c['muted']};
@define-color border {c['border']};
@define-color border-ui {c['border_ui']};
@define-color focus {c['focus']};
@define-color accent {c['accent']};
@define-color accent-2 {c['accent_2']};
@define-color diagnostic {c['diagnostic']};
@define-color error {c['error']};
@define-color success {c['sage']};
@define-color warning {c['warning']};

window#waybar {{
  background: {c['panel_rgba']};
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
  background: {c['active_rgba']};
  border-color: alpha(@focus, 0.82);
}}

#clock,
#battery,
#network,
#pulseaudio,
#cpu,
#memory,
#tray {{
  background: {c['module_rgba']};
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
  background: {c['panel_rgba']};
  background-alt: {c['surface0']};
  foreground: {c['text']};
  muted: {c['muted']};
  selected: {c['active_rgba']};
  active: {c['accent']};
  border-ui: {c['border_ui']};
  focus: {c['focus']};
  urgent: {c['error']};
  border-color: {c['border_ui']};
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
