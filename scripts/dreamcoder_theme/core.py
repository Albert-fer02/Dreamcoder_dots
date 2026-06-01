"""Core paths and small utilities for Dreamcoder Control Center."""

from __future__ import annotations

import json
import os
import shutil
import subprocess
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
PROFILE_DIR = ROOT / "profiles" / "dreamcoder"
VALID_STATUSES = {"ok", "warn", "fail", "skip"}


def config_home() -> Path:
    return Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))


def data_home() -> Path:
    return Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local" / "share"))


def active_hyprland_conf() -> Path:
    return config_home() / "hypr" / "hyprland.conf"


def active_hyprland_input_lua() -> Path:
    return config_home() / "hypr" / "input.lua"


def active_kitty_ui() -> Path:
    return config_home() / "kitty" / "dreamcoder-ui.conf"


def active_ghostty_config() -> Path:
    return config_home() / "ghostty" / "config"


def settings_path() -> Path:
    return config_home() / "dreamcoder" / "settings.json"


def active_profile_path() -> Path:
    return config_home() / "dreamcoder" / "profile.json"


def active_motion_path() -> Path:
    return config_home() / "dreamcoder" / "motion.json"


def read_json(path: Path, default: Any) -> Any:
    try:
        return json.loads(path.read_text())
    except (FileNotFoundError, json.JSONDecodeError):
        return default


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")


def emit(data: Any, as_json: bool) -> None:
    if as_json:
        print(json.dumps(data, indent=2, sort_keys=True))
        return
    if isinstance(data, dict):
        for key, value in data.items():
            if isinstance(value, (dict, list)):
                print(f"{key}: {json.dumps(value, sort_keys=True)}")
            else:
                print(f"{key}: {value}")
    else:
        print(data)


def replace_or_append_line(content: str, key: str, value: str) -> str:
    lines = content.splitlines()
    replacement = f"    {key} = {value}"
    for idx, line in enumerate(lines):
        if line.strip().startswith(f"{key} ="):
            lines[idx] = replacement
            return "\n".join(lines) + "\n"
    lines.append(replacement)
    return "\n".join(lines) + "\n"


def command_exists(name: str) -> bool:
    return shutil.which(name) is not None


def shell_stdout(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)


def detect_mode_from_file(path: Path) -> str:
    text = path.read_text(errors="ignore") if path.exists() else ""
    lowered = text.lower()
    if "dreamcoder light" in lowered:
        return "light"
    if "dreamcoder dusk" in lowered:
        return "dusk"
    if "dreamcoder dark" in lowered or "ember noir" in lowered:
        return "dark"
    return "unknown"
