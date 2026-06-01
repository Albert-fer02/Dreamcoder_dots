"""Motion presets and live terminal motion application."""

from __future__ import annotations

from typing import Any

from .core import active_ghostty_config, active_kitty_ui, active_motion_path, read_json
from .settings_store import settings_get

MOTION_PRESETS: dict[str, dict[str, Any]] = {
    "battery": {
        "name": "battery",
        "description": "Minimal animation for battery life and thermal comfort.",
        "kitty_cursor_trail": 0,
        "ghostty_cursor_shader": "off",
        "hyprland_animation": "fast",
        "performance_cost": 1,
    },
    "balanced": {
        "name": "balanced",
        "description": "Daily-driver motion with visible polish and low overhead.",
        "kitty_cursor_trail": 1,
        "ghostty_cursor_shader": "dreamcoder-cursor-pulse.glsl",
        "hyprland_animation": "default",
        "performance_cost": 2,
    },
    "fluid": {
        "name": "fluid",
        "description": "Responsive Dreamcoder motion tuned for laptop coding sessions.",
        "kitty_cursor_trail": 1,
        "ghostty_cursor_shader": "dreamcoder-cursor-pulse.glsl",
        "hyprland_animation": "smooth",
        "performance_cost": 3,
    },
    "cinematic": {
        "name": "cinematic",
        "description": "Maximum visual personality for demos and screenshots.",
        "kitty_cursor_trail": 1,
        "ghostty_cursor_shader": "dreamcoder-cursor-pulse.glsl",
        "hyprland_animation": "dynamic",
        "performance_cost": 5,
    },
}


def active_motion_name() -> str:
    configured = settings_get("motion.active")
    if isinstance(configured, str) and configured:
        return configured
    motion = read_json(active_motion_path(), {})
    name = motion.get("name")
    return str(name) if name else "unknown"


def apply_motion_files(preset: dict[str, Any]) -> None:
    kitty_ui = active_kitty_ui()
    if kitty_ui.exists():
        content = kitty_ui.read_text()
        value = str(preset.get("kitty_cursor_trail", 1))
        if "cursor_trail" in content:
            lines = [
                f"cursor_trail          {value}" if line.strip().startswith("cursor_trail") else line
                for line in content.splitlines()
            ]
            kitty_ui.write_text("\n".join(lines) + "\n")
        else:
            kitty_ui.write_text(content.rstrip() + f"\ncursor_trail          {value}\n")
    ghostty = active_ghostty_config()
    shader = str(preset.get("ghostty_cursor_shader", "off"))
    if ghostty.exists():
        content = ghostty.read_text()
        lines = []
        saw_shader = False
        saw_animation = False
        for line in content.splitlines():
            stripped = line.strip()
            if stripped.startswith("custom-shader ="):
                saw_shader = True
                if shader != "off":
                    lines.append(f"custom-shader = ~/.config/ghostty/shaders/{shader}")
                else:
                    lines.append("# custom-shader = ~/.config/ghostty/shaders/dreamcoder-cursor-pulse.glsl")
            elif stripped.startswith("custom-shader-animation ="):
                saw_animation = True
                lines.append(f"custom-shader-animation = {'false' if shader == 'off' else 'true'}")
            else:
                lines.append(line)
        if not saw_shader and shader != "off":
            lines.append(f"custom-shader = ~/.config/ghostty/shaders/{shader}")
        if not saw_animation:
            lines.append(f"custom-shader-animation = {'false' if shader == 'off' else 'true'}")
        ghostty.write_text("\n".join(lines) + "\n")
