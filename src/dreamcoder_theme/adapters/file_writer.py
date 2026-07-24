"""File system adapter implementing the Writer port."""

from __future__ import annotations

import os
import tempfile
from pathlib import Path

from ..ports.renderer import Writer


class FileWriter(Writer):
    """Writes files atomically using temp file + rename strategy."""

    def write(self, path: Path, content: str, *, atomic: bool = True) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        if atomic:
            fd, tmp = tempfile.mkstemp(dir=path.parent, prefix=f".{path.name}-")
            try:
                os.write(fd, content.encode())
            finally:
                os.close(fd)
            os.replace(tmp, path)
        else:
            path.write_text(content)

    def symlink(self, source: Path, target: Path) -> None:
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.is_symlink() or target.exists():
            target.unlink()
        target.symlink_to(source)
