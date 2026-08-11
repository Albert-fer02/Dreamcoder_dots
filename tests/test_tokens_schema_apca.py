"""Schema contract for the eight canonical APCA guardrail keys (task 1.8).

`tokens.schema.json` must define every APCA floor key as a property AND
require it, so a canonical token file missing any floor fails validation.
The heading keys closed the historical ``required``-list gap.
"""

import copy
import json
from pathlib import Path

import jsonschema
import pytest

ROOT = Path(__file__).resolve().parents[1]
THEME_ROOT = ROOT / "DreamcoderThemes" / "dreamcoder"

APCA_GUARDRAIL_KEYS = (
    "minimum_apca_body",
    "minimum_apca_body_dark",
    "minimum_apca_quiet",
    "minimum_apca_ui",
    "minimum_apca_ui_dark",
    "minimum_apca_on_accent",
    "minimum_apca_heading_light",
    "minimum_apca_heading_dark",
)


@pytest.fixture(scope="module")
def schema() -> dict:
    return json.loads((THEME_ROOT / "tokens.schema.json").read_text())


@pytest.fixture(scope="module")
def tokens() -> dict:
    return json.loads((THEME_ROOT / "tokens.json").read_text())


def test_all_apca_floor_keys_are_required(schema):
    required = set(schema["properties"]["guardrails"]["required"])
    for key in APCA_GUARDRAIL_KEYS:
        assert key in required, f"schema guardrails.required missing {key}"


def test_all_apca_floor_keys_are_defined_as_properties(schema):
    properties = schema["properties"]["guardrails"]["properties"]
    for key in APCA_GUARDRAIL_KEYS:
        assert key in properties, f"schema guardrails.properties missing {key}"


def test_tokens_json_validates_against_schema(schema, tokens):
    jsonschema.Draft202012Validator(schema).validate(tokens)


def test_tokens_json_contains_all_apca_floor_values(tokens):
    guardrails = tokens["guardrails"]
    for key in APCA_GUARDRAIL_KEYS:
        value = guardrails.get(key)
        assert isinstance(value, (int, float)), f"tokens.json guardrails missing {key}"


@pytest.mark.parametrize("missing_key", APCA_GUARDRAIL_KEYS)
def test_missing_any_apca_floor_key_fails_validation(schema, tokens, missing_key):
    incomplete = copy.deepcopy(tokens)
    del incomplete["guardrails"][missing_key]
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.Draft202012Validator(schema).validate(incomplete)
