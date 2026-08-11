"""Context-binding adapters for non-uniform renderer consumers.

Hexagonal-architecture-v2 design §4 / ADR-001: every special consumer
(transparent OpenCode, the palette-free Nvim dispatcher, named Zellij output,
version-bound Herdr) is exposed through a small adapter that binds its
target-specific context while presenting exactly the one
``render(palette: dict[str, str]) -> str`` port. There is exactly one renderer
contract; these adapters implement it.

Leaf renderer functions are imported lazily inside ``__call__`` so that
adapter modules never form an import cycle with the leaf modules that declare
their registrations.
"""

from __future__ import annotations

from typing import TYPE_CHECKING

from .renderer_contract import Palette

if TYPE_CHECKING:
    from .herdr_contract import HerdrProfile


class TransparentOpenCodeAdapter:
    """Binds ``transparent_background=True`` for the opencode consumer."""

    def __init__(self, transparent_background: bool = True) -> None:
        self._transparent_background = transparent_background

    def __call__(self, palette: Palette) -> str:
        from .renderers_opencode import opencode_content  # noqa: PLC0415

        return opencode_content(palette, transparent_background=self._transparent_background)


class NvimDispatcherAdapter:
    """Binds the Nvim dispatcher/profile context.

    The dispatcher string carries the active-mode/profile selection and does not
    consume the palette directly; mode-specific ``nvim_content`` stays the
    repository variant renderer (design §4).
    """

    def __call__(self, palette: Palette) -> str:
        from .renderers_extra_nvim import nvim_dispatcher_content  # noqa: PLC0415

        return nvim_dispatcher_content()


class NamedZellijAdapter:
    """Binds the KDL theme name for named Zellij theme output.

    The palette is rendered into the ``themes { <theme_name> { ... } }`` block.
    Per-mode theme-name expansion lands with Phase 2 ``ModeVariants``; PR 1 uses
    the stable theme name so the port stays one-palette/one-string.
    """

    def __init__(self, theme_name: str) -> None:
        self._theme_name = theme_name

    def __call__(self, palette: Palette) -> str:
        from .renderers_zellij import zellij_content  # noqa: PLC0415

        return zellij_content(palette, self._theme_name)


class VersionedHerdrAdapter:
    """Binds a complete ``HerdrProfile`` and render mode for version-bound output.

    Repository-only: produces the deterministic per-version config for the bound
    profile/mode; no live activation is introduced (design §4, §5 row 32).
    """

    def __init__(self, profile: HerdrProfile | None, mode: str) -> None:
        self._profile = profile
        self._mode = mode

    def __call__(self, palette: Palette) -> str:
        from .renderers_herdr import herdr_content  # noqa: PLC0415

        if self._profile is None:
            return ""
        return herdr_content(self._profile, self._mode, palette)
