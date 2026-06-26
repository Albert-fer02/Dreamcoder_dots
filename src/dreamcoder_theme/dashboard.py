"""Dashboard reporting for the Dreamcoder Control Center."""

from __future__ import annotations

import time
from typing import Any

from .backups import list_backups
from .core import config_home, detect_mode_from_file, settings_path
from .doctor import doctor_checks, summarize_checks
from .installer import installer_plan
from .motion import MOTION_PRESETS, active_motion_name
from .profiles import active_profile_name, load_profiles
from .repair_engine import repair_plan


def dashboard_report() -> dict[str, Any]:
    checks = [check.to_dict() for check in doctor_checks()]
    install = installer_plan()
    repair = repair_plan()
    profiles = load_profiles()
    backups = list_backups()
    return {
        "schema": "dreamcoder.dashboard.v1",
        "generated_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "state": {
            "theme_mode": detect_mode_from_file(config_home() / "kitty" / "colors-dreamcoder.conf"),
            "profile": active_profile_name(),
            "motion": active_motion_name(),
            "settings_path": str(settings_path()),
        },
        "catalog": {"profiles": sorted(profiles), "motion_presets": sorted(MOTION_PRESETS)},
        "health": {"summary": summarize_checks(checks), "checks": checks},
        "installer": {
            "conflicts": len(install["conflicts"]),
            "managed": sum(1 for target in install["targets"] if target["status"] == "managed"),
            "missing": sum(1 for target in install["targets"] if target["status"] == "missing"),
        },
        "repair": repair["summary"],
        "backups": {"count": len(backups), "latest": backups[0]["backup_id"] if backups else None},
        "commands": {
            "doctor": "./scripts/dreamcoder doctor-json",
            "repair_plan": "./scripts/dreamcoder repair plan --json",
            "repair_apply": "./scripts/dreamcoder repair apply --dry-run --json",
            "profile": "./scripts/dreamcoder profile apply asus-vivobook15 --dry-run --json",
            "motion": "./scripts/dreamcoder motion apply fluid --dry-run --json",
            "installer": "./scripts/dreamcoder installer plan --json",
            "verify": "./scripts/verify.sh",
        },
    }


def dashboard_markdown(report: dict[str, Any]) -> str:
    state = report["state"]
    health = report["health"]["summary"]
    installer = report["installer"]
    repair = report["repair"]
    backups = report["backups"]
    commands = report["commands"]
    lines = [
        "# Dreamcoder Control Center",
        "",
        "## Current State",
        f"- Theme mode: `{state['theme_mode']}`",
        f"- Profile: `{state['profile']}`",
        f"- Motion: `{state['motion']}`",
        f"- Settings: `{state['settings_path']}`",
        "",
        "## Health",
        f"- OK: `{health['ok']}`",
        f"- Warn: `{health['warn']}`",
        f"- Fail: `{health['fail']}`",
        f"- Skip: `{health['skip']}`",
        "",
        "## Safety",
        f"- Installer conflicts: `{installer['conflicts']}`",
        f"- Managed targets: `{installer['managed']}`",
        f"- Missing targets: `{installer['missing']}`",
        f"- Repair actions: `{repair['actions']}` total / `{repair['safe']}` safe / `{repair['manual']}` manual",
        f"- Backup manifests: `{backups['count']}`",
        "",
        "## Operator Commands",
    ]
    lines.extend(f"- `{command}`" for command in commands.values())
    return "\n".join(lines) + "\n"
