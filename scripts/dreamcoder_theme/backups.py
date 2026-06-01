"""Manifest-based backup and restore primitives."""

from __future__ import annotations

import shutil
import time
from pathlib import Path
from typing import Any

from .core import data_home, read_json, write_json


def backup_root() -> Path:
    return data_home() / "dreamcoder" / "backups"


def backup_manifest_path(backup_id: str) -> Path:
    return backup_root() / backup_id / "manifest.json"


def path_backup_name(path: Path) -> Path:
    resolved = path.expanduser()
    parts = [part for part in resolved.parts if part not in {resolved.anchor, "/"}]
    return Path(*parts) if parts else Path("root")


def create_backup(paths: list[Path], reason: str) -> dict[str, Any]:
    backup_id = time.strftime("%Y%m%d-%H%M%S") + f"-{__import__('os').getpid()}"
    root = backup_root() / backup_id
    files_dir = root / "files"
    entries: list[dict[str, Any]] = []
    for raw in paths:
        path = raw.expanduser()
        backup_rel = path_backup_name(path)
        backup_path = files_dir / backup_rel
        entry: dict[str, Any] = {
            "path": str(path),
            "backup": str(backup_path),
            "existed": path.exists() or path.is_symlink(),
            "is_dir": path.is_dir() and not path.is_symlink(),
        }
        if entry["existed"]:
            backup_path.parent.mkdir(parents=True, exist_ok=True)
            if entry["is_dir"]:
                shutil.copytree(path, backup_path, symlinks=True)
            else:
                shutil.copy2(path, backup_path, follow_symlinks=False)
        entries.append(entry)
    manifest = {
        "schema": "dreamcoder.backup.v1",
        "backup_id": backup_id,
        "created_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "reason": reason,
        "files": entries,
    }
    write_json(root / "manifest.json", manifest)
    return manifest


def list_backups() -> list[dict[str, Any]]:
    manifests = []
    for manifest_path in sorted(backup_root().glob("*/manifest.json"), reverse=True):
        manifests.append(read_json(manifest_path, {}))
    return manifests


def restore_backup(backup_id: str, dry_run: bool) -> dict[str, Any]:
    manifest = read_json(backup_manifest_path(backup_id), None)
    if not manifest:
        raise FileNotFoundError(f"Backup not found: {backup_id}")
    planned = [entry["path"] for entry in manifest.get("files", [])]
    if not dry_run:
        for entry in manifest.get("files", []):
            target = Path(entry["path"])
            backup = Path(entry["backup"])
            if entry.get("existed"):
                target.parent.mkdir(parents=True, exist_ok=True)
                if target.exists() or target.is_symlink():
                    if target.is_dir() and not target.is_symlink():
                        shutil.rmtree(target)
                    else:
                        target.unlink()
                if entry.get("is_dir"):
                    shutil.copytree(backup, target, symlinks=True)
                else:
                    shutil.copy2(backup, target, follow_symlinks=False)
            elif target.exists() or target.is_symlink():
                if target.is_dir() and not target.is_symlink():
                    shutil.rmtree(target)
                else:
                    target.unlink()
    return {"backup_id": backup_id, "dry_run": dry_run, "planned_restore": planned}
