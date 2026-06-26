"""Machine profiles and profile application helpers."""

from __future__ import annotations

from typing import Any

from .core import (
    PROFILE_DIR,
    active_hyprland_conf,
    active_hyprland_input_lua,
    active_profile_path,
    read_json,
    replace_or_append_line,
)
from .settings_store import settings_get


def load_profiles() -> dict[str, dict[str, Any]]:
    profiles: dict[str, dict[str, Any]] = {}
    for path in sorted(PROFILE_DIR.glob("*.json")):
        data = read_json(path, {})
        name = data.get("name", path.stem)
        profiles[name] = data
    return profiles


def active_profile_name() -> str:
    configured = settings_get("profile.active")
    if isinstance(configured, str) and configured:
        return configured
    profile = read_json(active_profile_path(), {})
    name = profile.get("name")
    return str(name) if name else "unknown"


def profile_changes(profile: dict[str, Any]) -> dict[str, str]:
    monitor = str(profile.get("monitor", "auto"))
    keyboard = str(profile.get("keyboard_layout", "latam"))
    repeat_rate = str(profile.get("repeat_rate", 40))
    repeat_delay = str(profile.get("repeat_delay", 300))
    shell = str(profile.get("shell", "fish --login"))
    mode = str(profile.get("terminal_default_mode", "light"))
    return {
        "hyprland:monitor": monitor,
        "hyprland:input:kb_layout": keyboard,
        "hyprland:input:repeat_rate": repeat_rate,
        "hyprland:input:repeat_delay": repeat_delay,
        "input:repeat_rate": repeat_rate,
        "input:repeat_delay": repeat_delay,
        "terminal:shell": shell,
        "dreamcoder:theme_mode": mode,
    }


def apply_profile_files(profile: dict[str, Any]) -> None:
    hypr = active_hyprland_conf()
    if hypr.exists():
        content = hypr.read_text()
        content = replace_or_append_line(
            content, "repeat_rate", str(profile.get("repeat_rate", 40))
        )
        content = replace_or_append_line(
            content, "repeat_delay", str(profile.get("repeat_delay", 300))
        )
        hypr.write_text(content)
    input_lua = active_hyprland_input_lua()
    if input_lua.exists():
        content = input_lua.read_text()
        content = replace_or_append_line(
            content, "repeat_rate", str(profile.get("repeat_rate", 40)) + ","
        )
        content = replace_or_append_line(
            content, "repeat_delay", str(profile.get("repeat_delay", 300)) + ","
        )
        input_lua.write_text(content)
