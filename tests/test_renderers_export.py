"""Test that renderers.py exports all available renderer functions."""

import importlib
import inspect
from pathlib import Path

from dreamcoder_theme import renderers

RENDERERS_DIR = Path(__file__).resolve().parents[1] / "src/dreamcoder_theme"


def _discover_renderer_modules() -> list[str]:
    """Return names of all renderers_*.py modules (excluding renderers.py itself)."""
    modules = []
    for f in sorted(RENDERERS_DIR.glob("renderers_*.py")):
        name = f.stem  # e.g. renderers_kitty
        if name != "renderers":  # skip the hub itself
            modules.append(name)
    return modules


def _get_renderer_functions(module_name: str) -> set[str]:
    """Return set of public renderer-content function names from a module.

    A renderer function is named like <target>_content or is an explicit
    public token function (opencode_tokens). Utility imports like guard,
    mix, detect_mode, ansi are NOT renderer functions.
    """
    try:
        mod = importlib.import_module(f"dreamcoder_theme.{module_name}")
    except Exception:
        return set()
    # Hard-coded known content suffixes + opencode_tokens for the hub
    return {
        name
        for name, obj in inspect.getmembers(mod, inspect.isfunction)
        if (
            not name.startswith("_")
            and (name.endswith("_content") or name == "opencode_tokens")
            and not name.startswith("nvim_")
        )
        or name
        in {
            "nvim_content",
            "nvim_dispatcher_content",
            "hypr_colors_conf_content",
            "hypr_colors_lua_content",
            "rofi_matugen_content",
            "waybar_matugen_content",
        }
    }


def test_renderers_all_contains_all_public_functions():
    """Every public function in every renderers_*.py must be in renderers.__all__."""

    exported = set(renderers.__all__)
    missing: list[str] = []

    for mod_name in _discover_renderer_modules():
        for func in _get_renderer_functions(mod_name):
            if func not in exported:
                missing.append(f"{mod_name}.{func}")

    assert not missing, (
        f"Functions missing from renderers.__all__: {missing}\n"
        f"Add them to src/dreamcoder_theme/renderers.py"
    )


def test_renderers_all_no_stale_exports():
    """Every name in renderers.__all__ must exist in some renderer module."""

    exported = set(renderers.__all__)
    all_funcs: set[str] = set()
    for mod_name in _discover_renderer_modules():
        all_funcs |= _get_renderer_functions(mod_name)

    stale = [name for name in sorted(exported) if name not in all_funcs]
    assert not stale, (
        f"Names in renderers.__all__ that don't exist in any module: {stale}\n"
        f"Remove them from src/dreamcoder_theme/renderers.py"
    )
