"""Version-bound runtime contract selection for Herdr integrations."""

from __future__ import annotations

import re
from collections.abc import Mapping
from dataclasses import dataclass
from enum import StrEnum
from typing import Any

_VERSION_OUTPUT = re.compile(r"\bherdr\s+(\d+\.\d+\.\d+)\b", re.IGNORECASE)
_SHA256 = re.compile(r"[0-9a-f]{64}\Z")


class ContractStatus(StrEnum):
    """Outcome of matching runtime output to compatibility evidence."""

    SKIPPED_NOT_INSTALLED = "skipped-not-installed"
    SUPPORTED = "supported"
    UNSUPPORTED_CONTRACT = "unsupported-contract"


@dataclass(frozen=True)
class ProcedureEvidence:
    """Evidence that an operational procedure exists and is unambiguous."""

    available: bool
    unambiguous: bool
    observable: bool = True

    @classmethod
    def from_mapping(cls, value: object) -> ProcedureEvidence:
        if not isinstance(value, Mapping):
            return cls(available=False, unambiguous=False, observable=False)
        available = value.get("available")
        unambiguous = value.get("unambiguous")
        observable = value.get("observable", True)
        return cls(
            available=available if isinstance(available, bool) else False,
            unambiguous=unambiguous if isinstance(unambiguous, bool) else False,
            observable=observable if isinstance(observable, bool) else False,
        )

    @property
    def is_complete(self) -> bool:
        return self.available and self.unambiguous and self.observable


@dataclass(frozen=True)
class ContractEvidence:
    """Sanitized version-bound evidence required before Herdr can be enabled."""

    profile_id: str
    executable: str
    version: str
    source_identity: str
    source_sha256: str
    default_config_path: str
    config_path_environment: str
    color_representation: str | None
    base_theme_name: str
    allowed_theme_fields: tuple[str, ...]
    allowed_custom_fields: tuple[str, ...]
    candidate_validation: ProcedureEvidence
    server_applicability: ProcedureEvidence
    reload: ProcedureEvidence
    restoration: ProcedureEvidence

    @classmethod
    def from_mapping(cls, value: Mapping[str, Any]) -> ContractEvidence:
        def text(name: str) -> str:
            candidate = value.get(name)
            return candidate if isinstance(candidate, str) else ""

        def strings(name: str) -> tuple[str, ...]:
            candidate = value.get(name)
            if not isinstance(candidate, list) or not all(
                isinstance(item, str) for item in candidate
            ):
                return ()
            return tuple(candidate)

        color_representation = value.get("color_representation")
        return cls(
            profile_id=text("profile_id"),
            executable=text("executable"),
            version=text("version"),
            source_identity=text("source_identity"),
            source_sha256=text("source_sha256"),
            default_config_path=text("default_config_path"),
            config_path_environment=text("config_path_environment"),
            color_representation=(
                color_representation if isinstance(color_representation, str) else None
            ),
            base_theme_name=text("base_theme_name"),
            allowed_theme_fields=strings("allowed_theme_fields"),
            allowed_custom_fields=strings("allowed_custom_fields"),
            candidate_validation=ProcedureEvidence.from_mapping(value.get("candidate_validation")),
            server_applicability=ProcedureEvidence.from_mapping(value.get("server_applicability")),
            reload=ProcedureEvidence.from_mapping(value.get("reload")),
            restoration=ProcedureEvidence.from_mapping(value.get("restoration")),
        )

    @property
    def is_complete(self) -> bool:
        """Require every asserted behavior before any profile can be enabled."""
        return all(
            (
                bool(self.profile_id),
                self.executable == "herdr",
                bool(_VERSION_OUTPUT.fullmatch(f"herdr {self.version}")),
                bool(self.source_identity),
                bool(_SHA256.fullmatch(self.source_sha256)),
                bool(self.default_config_path),
                bool(self.config_path_environment),
                bool(self.color_representation),
                bool(self.base_theme_name),
                bool(self.allowed_theme_fields),
                bool(self.allowed_custom_fields),
                self.candidate_validation.is_complete,
                self.server_applicability.is_complete,
                self.reload.is_complete,
                self.restoration.is_complete,
            )
        )


@dataclass(frozen=True)
class HerdrProfile:
    """A profile is usable only when all evidence is complete."""

    evidence: ContractEvidence

    @property
    def is_complete(self) -> bool:
        return self.evidence.is_complete


@dataclass(frozen=True)
class ProfileSelection:
    """A non-mutating contract-selection result."""

    status: ContractStatus
    profile: HerdrProfile | None = None


def profile_from_evidence(evidence: ContractEvidence) -> HerdrProfile:
    """Create a profile without allowing callers to override completeness."""
    return HerdrProfile(evidence=evidence)


HERDR_073_EVIDENCE = ContractEvidence(
    profile_id="herdr-0.7.3",
    executable="herdr",
    version="0.7.3",
    source_identity=(
        "Herdr v0.7.3 official configuration reference; source commit "
        "299dd4163a96381ec2d8e5bde13d7ba6d6432373"
    ),
    source_sha256="043ef43ecbabda28465dcff1eec3184518150d567b8b8f20cda9c6c88770641d",
    default_config_path="<HOME>/.config/herdr/config.toml",
    config_path_environment="HERDR_CONFIG_PATH",
    color_representation="hex (#RRGGBB)",
    base_theme_name="catppuccin",
    allowed_theme_fields=("name", "auto_switch", "dark_name", "light_name"),
    allowed_custom_fields=(
        "accent",
        "panel_bg",
        "surface0",
        "surface1",
        "surface_dim",
        "overlay0",
        "overlay1",
        "text",
        "subtext0",
        "mauve",
        "green",
        "yellow",
        "red",
        "blue",
        "teal",
        "peach",
    ),
    candidate_validation=ProcedureEvidence(available=True, unambiguous=True),
    server_applicability=ProcedureEvidence(available=True, unambiguous=True),
    reload=ProcedureEvidence(available=True, unambiguous=True, observable=True),
    restoration=ProcedureEvidence(available=True, unambiguous=True),
)
HERDR_073_PROFILE = HerdrProfile(evidence=HERDR_073_EVIDENCE)
SUPPORTED_PROFILES = (HERDR_073_PROFILE,)


def detect_profile(
    version_output: str | None, *, profiles: tuple[HerdrProfile, ...] = SUPPORTED_PROFILES
) -> ProfileSelection:
    """Match exact version output without guessing malformed runtime output."""
    if version_output is None:
        return ProfileSelection(status=ContractStatus.SKIPPED_NOT_INSTALLED)

    match = _VERSION_OUTPUT.search(version_output)
    if match is None:
        return ProfileSelection(status=ContractStatus.UNSUPPORTED_CONTRACT)

    version = match.group(1)
    for profile in profiles:
        if profile.is_complete and profile.evidence.version == version:
            return ProfileSelection(status=ContractStatus.SUPPORTED, profile=profile)
    return ProfileSelection(status=ContractStatus.UNSUPPORTED_CONTRACT)
