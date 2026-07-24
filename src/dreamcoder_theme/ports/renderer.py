"""Port interfaces for Dreamcoder theme engine.

Abstract base classes defining contracts between application and infrastructure layers.
"""

from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass
from pathlib import Path


@dataclass
class RenderResult:
    target_name: str
    output_path: str
    content: str
    mode: str


class Renderer(ABC):
    """Contract for theme target renderers (Kitty, Waybar, Ghostty, etc.)."""

    @abstractmethod
    def render(self, tokens: dict[str, str]) -> RenderResult:
        """Transform Dreamcoder tokens into target-specific output."""
        ...

    @property
    @abstractmethod
    def target_name(self) -> str:
        """Unique identifier for this renderer target."""
        ...


class Writer(ABC):
    """Contract for file output operations."""

    @abstractmethod
    def write(self, path: Path, content: str, *, atomic: bool = True) -> None:
        """Write content to path. Atomic by default (temp file + rename)."""
        ...

    @abstractmethod
    def symlink(self, source: Path, target: Path) -> None:
        """Create or update a symbolic link."""
        ...
