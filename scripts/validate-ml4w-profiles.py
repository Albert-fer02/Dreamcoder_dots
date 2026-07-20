#!/usr/bin/env python3
"""
Validate Dreamcoder ML4W profiles against the schema and conventions.

Usage:
    python3 scripts/validate-ml4w-profiles.py                    # validate all profiles
    python3 scripts/validate-ml4w-profiles.py --ci               # exit 1 on first error
    python3 scripts/validate-ml4w-profiles.py --profile asus-vivobook15  # single profile
"""

import json
import re
import sys
from pathlib import Path
from typing import Any

try:
    import jsonschema
except ImportError:
    jsonschema = None  # type: ignore[assignment]

REPO_ROOT = Path(__file__).resolve().parent.parent
PROFILES_DIR = REPO_ROOT / "DreamcoderProfiles" / "dreamcoder"
SCHEMA_FILE = PROFILES_DIR / "profile.schema.json"

KEY_PATTERN = re.compile(r"^[A-Z0-9_]+$|^code:[0-9]+$|^F(?:1[0-2]?|[2-9])$")
VALID_MODS = {"SUPER", "SHIFT", "CTRL", "ALT", "CTRL_SHIFT", "SUPER_SHIFT"}


def load_json(path: Path) -> dict[str, Any]:
    """Load a JSON file, returning empty dict on failure."""
    try:
        with open(path) as f:
            result: dict[str, Any] = json.load(f)
            return result
    except (json.JSONDecodeError, FileNotFoundError, PermissionError) as e:
        print(f"  ❌ Cannot load {path.name}: {e}")
        return {}


def _load_or_fail(path: Path) -> dict[str, Any]:
    """Load a JSON file, exiting on failure."""
    try:
        with open(path) as f:
            result: dict[str, Any] = json.load(f)
            return result
    except (json.JSONDecodeError, FileNotFoundError, PermissionError) as e:
        print(f"  ❌ Fatal: Cannot load {path}: {e}")
        sys.exit(1)


def validate_schema(profile_path: Path, schema: dict[str, Any]) -> list[str]:
    """Validate a profile against the JSON Schema."""
    errors: list[str] = []

    if jsonschema is None:
        errors.append(
            f"  ⚠ jsonschema not installed — skipping schema validation for {profile_path.name}"
        )
        return errors

    data = load_json(profile_path)
    if not data:
        errors.append(f"  ❌ {profile_path.name}: could not load profile")
        return errors

    try:
        jsonschema.validate(instance=data, schema=schema)
    except jsonschema.ValidationError as e:
        errors.append(f"  ❌ {profile_path.name}: schema error — {e.message}")
    except json.JSONDecodeError as e:
        errors.append(f"  ❌ {profile_path.name}: invalid JSON — {e}")

    return errors


def validate_conventions(profile_path: Path) -> list[str]:
    """Validate profile-specific conventions not covered by schema."""
    errors: list[str] = []
    try:
        data = load_json(profile_path)
    except (json.JSONDecodeError, FileNotFoundError) as e:
        return [f"  ❌ {profile_path.name}: {e}"]

    if not data:
        return [f"  ❌ {profile_path.name}: could not load profile"]

    name = profile_path.stem
    bindings = data.get("keybindings", {}).get("bindings", [])

    # Check name matches filename
    if data.get("name") != name:
        errors.append(
            f"  ❌ {profile_path.name}: 'name' field ('{data.get('name')}') must match filename '{name}'"
        )

    if not bindings:
        errors.append(f"  ⚠ {profile_path.name}: no keybindings defined")

    seen = set()
    for i, b in enumerate(bindings):
        key = b.get("key", "")
        mods = tuple(b.get("mods", []))
        desc = b.get("description", "")

        # Key pattern check
        if not KEY_PATTERN.match(key):
            errors.append(f"  ❌ {profile_path.name} binding[{i}]: invalid key '{key}'")

        # Valid mods
        for m in mods:
            if m not in VALID_MODS:
                errors.append(f"  ❌ {profile_path.name} binding[{i}]: invalid modifier '{m}'")

        # Fn keys / keycodes must have empty mods
        if (key.startswith("F") or key.startswith("code:")) and len(mods) > 0:
            errors.append(
                f"  ❌ {profile_path.name} binding[{i}]: Fn/keycode '{key}' should have empty mods"
            )

        # SUPER modifier check: must be first in mods
        if len(mods) > 0 and "SUPER" in mods and mods[0] != "SUPER":
            errors.append(
                f"  ⚠ {profile_path.name} binding[{i}]: SUPER should be first in mods array"
            )

        # Duplicate detection
        sig = (key, mods)
        if sig in seen:
            errors.append(
                f"  ❌ {profile_path.name} binding[{i}]: duplicate {key} with mods {list(mods)}"
            )
        seen.add(sig)

        # Description format: should be capitalized
        if desc and desc[0].islower():
            errors.append(
                f"  ⚠ {profile_path.name} binding[{i}]: description should start with uppercase"
            )

    return errors


def _parse_args() -> tuple[bool, str | None]:
    """Parse CLI args, return (ci_mode, single_profile)."""
    ci_mode = "--ci" in sys.argv
    single_profile: str | None = None

    for arg in sys.argv[1:]:
        if arg.startswith("--profile="):
            single_profile = arg.split("=", 1)[1]
        elif arg == "--profile" and len(sys.argv) > sys.argv.index(arg) + 1:
            idx = sys.argv.index(arg)
            single_profile = sys.argv[idx + 1]
        elif arg in ("--ci",):
            continue
        elif arg.startswith("--"):
            print(f"Unknown option: {arg}")
            sys.exit(1)

    return ci_mode, single_profile


def _validate_profiles(schema: dict[str, Any], single_profile: str | None) -> list[str]:
    """Validate all profiles against schema and conventions."""
    all_errors: list[str] = []

    for pf in sorted(PROFILES_DIR.glob("*.json")):
        if pf.name == "profile.schema.json":
            continue
        if single_profile and pf.stem != single_profile:
            continue

        print(f"\n  📄 {pf.name}")
        errors = validate_schema(pf, schema)
        all_errors.extend(errors)
        for e in errors:
            print(e)

        conv_errors = validate_conventions(pf)
        all_errors.extend(conv_errors)
        for e in conv_errors:
            print(e)

        if not errors and not conv_errors:
            print("  ✅ passes all checks")

    return all_errors


def main() -> None:
    """Entry point: parse args, load schema, run validation."""
    ci_mode, single_profile = _parse_args()

    schema_path = SCHEMA_FILE if SCHEMA_FILE.exists() else None
    if not schema_path:
        print(f"  ❌ Schema file not found: {SCHEMA_FILE}")
        sys.exit(1)

    schema = _load_or_fail(schema_path)
    all_errors = _validate_profiles(schema, single_profile)

    print(f"\n{'─' * 50}")
    if all_errors:
        print(f"  ❌ {len(all_errors)} issue(s) found")
        if ci_mode:
            sys.exit(1)
    else:
        print("  🎉 All profiles clean!")


if __name__ == "__main__":
    main()
