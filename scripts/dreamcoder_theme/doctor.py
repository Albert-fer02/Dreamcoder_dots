"""Structured health checks for Dreamcoder Dots."""

from __future__ import annotations

import shutil
from dataclasses import asdict, dataclass

from .core import VALID_STATUSES, command_exists, config_home, detect_mode_from_file, shell_stdout
from .installer import installer_plan


@dataclass(frozen=True)
class HealthCheck:
    name: str
    status: str
    detail: str
    repair: str

    def to_dict(self) -> dict[str, str]:
        if self.status not in VALID_STATUSES:
            raise ValueError(f"Invalid health status: {self.status}")
        return asdict(self)


def summarize_checks(checks: list[dict[str, str]]) -> dict[str, int]:
    return {
        "ok": sum(1 for check in checks if check["status"] == "ok"),
        "warn": sum(1 for check in checks if check["status"] == "warn"),
        "fail": sum(1 for check in checks if check["status"] == "fail"),
        "skip": sum(1 for check in checks if check["status"] == "skip"),
    }


def doctor_checks() -> list[HealthCheck]:
    ch = config_home()
    checks: list[HealthCheck] = []
    critical_paths = {
        "kitty config": ch / "kitty",
        "ghostty config": ch / "ghostty",
        "starship config": ch / "starship.toml",
        "fish config": ch / "fish" / "config.fish",
    }
    for name, path in critical_paths.items():
        checks.append(HealthCheck(
            name=name,
            status="ok" if path.exists() else "fail",
            detail=str(path),
            repair="./scripts/dreamcoder repair",
        ))

    kitty_ui = ch / "kitty" / "dreamcoder-ui.conf"
    duplicate_include = kitty_ui.exists() and any(
        line.strip() == "include colors-dreamcoder.conf"
        for line in kitty_ui.read_text(errors="ignore").splitlines()
    )
    checks.append(HealthCheck(
        name="kitty duplicate color include",
        status="fail" if duplicate_include else "ok",
        detail="dreamcoder-ui.conf must not include colors-dreamcoder.conf after kitty.conf already does",
        repair="./scripts/dreamcoder sync",
    ))

    mode = detect_mode_from_file(ch / "kitty" / "colors-dreamcoder.conf")
    checks.append(HealthCheck(
        name="active theme mode",
        status="ok" if mode in {"light", "dusk", "dark"} else "warn",
        detail=mode,
        repair="./scripts/dreamcoder auto",
    ))

    checks.append(HealthCheck(
        name="starship binary",
        status="ok" if command_exists("starship") else "fail",
        detail=shutil.which("starship") or "missing",
        repair="Install starship, then run ./scripts/dreamcoder repair",
    ))
    checks.append(HealthCheck(
        name="fish binary",
        status="ok" if command_exists("fish") else "fail",
        detail=shutil.which("fish") or "missing",
        repair="Install fish, then run ./scripts/dreamcoder repair",
    ))

    timer_status = "skip"
    timer_detail = "systemctl unavailable"
    if command_exists("systemctl"):
        result = shell_stdout(["systemctl", "--user", "is-active", "dreamcoder-theme-auto.timer"])
        timer_detail = (result.stdout or result.stderr).strip() or "unknown"
        timer_status = "ok" if result.returncode == 0 and timer_detail == "active" else "warn"
    checks.append(HealthCheck(
        name="day/night timer",
        status=timer_status,
        detail=timer_detail,
        repair="systemctl --user enable --now dreamcoder-theme-auto.timer",
    ))

    conflicts = installer_plan()["conflicts"]
    checks.append(HealthCheck(
        name="installer conflicts",
        status="ok" if not conflicts else "warn",
        detail=f"{len(conflicts)} conflict(s)",
        repair="./scripts/dreamcoder installer plan --json",
    ))
    return checks


def doctor_report() -> dict[str, object]:
    checks = [check.to_dict() for check in doctor_checks()]
    return {"schema": "dreamcoder.doctor.v1", "summary": summarize_checks(checks), "checks": checks}
