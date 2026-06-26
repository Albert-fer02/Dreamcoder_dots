"""Filesystem writers and app config updaters."""

from __future__ import annotations

import json
import os
import re
import shutil
import subprocess
from pathlib import Path


def write_if_changed(path: Path, content: str) -> bool:
    old = path.read_text() if path.exists() else ""
    if old == content:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)
    return True


def write_opencode_tui(path: Path) -> bool:
    data = {}
    if path.exists():
        try:
            data = json.loads(path.read_text())
        except json.JSONDecodeError:
            data = {}
    data["$schema"] = data.get("$schema", "https://opencode.ai/tui.json")
    data["theme"] = "dreamcoder"
    return write_if_changed(path, json.dumps(data, indent=2) + "\n")


def cleanup_opencode_themes(path: Path) -> bool:
    changed = False
    keep = path.name
    if os.environ.get("DREAMCODER_CLEAN_OPENCODE_THEMES", "1") == "0":
        return False
    for theme in path.parent.glob("*.json"):
        if theme.name != keep:
            theme.unlink()
            changed = True
    return changed


def ensure_codex_theme_config(path: Path) -> bool:
    theme_line = 'theme = "Dreamcoder"'
    if not path.exists():
        return write_if_changed(path, f"[tui]\n{theme_line}\n")
    content = path.read_text()
    if re.search(r"(?m)^\s*theme\s*=", content) and "[tui]" in content:
        return False
    if "[tui]" in content:
        updated = re.sub(r"(?m)^\[tui\]\s*$", f"[tui]\n{theme_line}", content, count=1)
    else:
        updated = content.rstrip() + f"\n\n[tui]\n{theme_line}\n"
    return write_if_changed(path, updated)


def ensure_pi_theme_settings(path: Path) -> bool:
    data: dict = {}
    if path.exists():
        try:
            data = json.loads(path.read_text())
        except json.JSONDecodeError:
            data = {}
    if data.get("theme") == "dreamcoder":
        return False
    data["theme"] = "dreamcoder"
    return write_if_changed(path, json.dumps(data, indent=2) + "\n")


def valid_starship(path: Path) -> bool:
    if not shutil.which("starship"):
        return True
    return (
        subprocess.run(
            ["starship", "explain"],
            env={**os.environ, "STARSHIP_CONFIG": str(path)},
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
            timeout=10,
        ).returncode
        == 0
    )


def ensure_kitty_ui_include(path: Path) -> bool:
    line = "include dreamcoder-ui.conf"
    if not path.exists():
        return False
    content = path.read_text()
    if line in content:
        return False
    path.write_text(
        content.rstrip() + "\n\n# Dreamcoder readability override\n" + line + "\n"
    )
    return True


def update_ghostty_theme(path: Path, mode: str) -> bool:
    """Update Ghostty config to use the correct theme name, opacity, and blur."""
    if not path.exists():
        return False
    content = path.read_text()
    theme_name = f"dreamcoder-{mode}" if mode != "light" else "dreamcoder"

    # Mode-aware visual settings for glass coherence with Kitty
    if mode == "dark":
        opacity_val = "0.76"
        blur_val = "20"
    else:
        opacity_val = "0.96"
        blur_val = "false"

    changed = False

    # Theme line
    if re.search(rf"theme\s*=\s*{re.escape(theme_name)}(?:\s|$)", content):
        pass  # already correct
    elif re.search(r"theme\s*=", content):
        content = re.sub(r"theme\s*=.*", f"theme = {theme_name}", content)
        changed = True
    else:
        content = content.rstrip() + f"\n\n# Theme\ntheme = {theme_name}\n"
        changed = True

    # background-opacity
    op_re = re.compile(r"^background-opacity\s*=.*", re.MULTILINE)
    op_line = f"background-opacity = {opacity_val}"
    if op_re.search(content):
        if op_re.search(content).group() != op_line:
            content = op_re.sub(op_line, content)
            changed = True
    else:
        content += f"\n{op_line}"
        changed = True

    # background-blur
    bl_re = re.compile(r"^background-blur\s*=.*", re.MULTILINE)
    bl_line = f"background-blur = {blur_val}"
    if bl_re.search(content):
        if bl_re.search(content).group() != bl_line:
            content = bl_re.sub(bl_line, content)
            changed = True
    else:
        content += f"\n{bl_line}"
        changed = True

    return write_if_changed(path, content) if changed else False


def update_warp_settings(path: Path, mode: str) -> bool:
    """Patch Warp settings.toml with mode-aware opacity/blur for glass coherence."""
    if mode == "dark":
        opacity_val = 76
        blur_val = 20
        blur_texture = True
    else:
        opacity_val = 96
        blur_val = 1
        blur_texture = False

    section_header = "[appearance.window]"
    expected = (
        f"{section_header}\n"
        f"override_opacity = {opacity_val}\n"
        f"override_blur = {blur_val}\n"
        f"override_blur_texture = {str(blur_texture).lower()}\n"
    )

    if path.exists():
        content = path.read_text()
        # Check if section exists and already correct
        sec_re = re.compile(r"^\[appearance\.window\].*?(?=^\[|\Z)", re.MULTILINE | re.DOTALL)
        existing_section = sec_re.search(content)
        if existing_section and existing_section.group().strip() == expected.strip():
            return False
        # Replace or append section
        if existing_section:
            patched = content.replace(existing_section.group(), expected)
        else:
            patched = content.rstrip() + "\n\n" + expected
    else:
        patched = expected

    path.parent.mkdir(parents=True, exist_ok=True)
    return write_if_changed(path, patched)


def write_variant_files(
    base: Path,
    names: dict[str, str],
    builder,
    variants: dict[str, dict[str, str]],
) -> list[bool]:
    return [
        write_if_changed(base / file_name, builder(variants[mode_name]))
        for mode_name, file_name in names.items()
    ]
