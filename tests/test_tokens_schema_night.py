"""Schema contract for the canonical `render_profiles.night` parameters (task 2.2).

`tokens.schema.json` must require `render_profiles.night` and bound its four
parameters: brightness/saturation factors in (0, 1], `maximum_corrective_delta`
in [0, 0.20], and `corrective_step` in (0, maximum_corrective_delta]. JSON
Schema cannot express the relative `corrective_step <= maximum_corrective_delta`
bound, so the schema bounds `corrective_step` to (0, 0.20] and the cross-field
invariant is enforced by the runtime loader (task 2.5) and asserted here.
"""

import copy
import json
from pathlib import Path

import jsonschema
import pytest

ROOT = Path(__file__).resolve().parents[1]
THEME_ROOT = ROOT / "DreamcoderThemes" / "dreamcoder"

NIGHT_KEYS = (
    "brightness_factor",
    "saturation_factor",
    "maximum_corrective_delta",
    "corrective_step",
)


@pytest.fixture(scope="module")
def schema() -> dict:
    return json.loads((THEME_ROOT / "tokens.schema.json").read_text())


@pytest.fixture(scope="module")
def tokens() -> dict:
    return json.loads((THEME_ROOT / "tokens.json").read_text())


@pytest.fixture(scope="module")
def validator(schema: dict) -> jsonschema.Draft202012Validator:
    return jsonschema.Draft202012Validator(schema)


def test_render_profiles_required_in_schema(schema):
    assert "render_profiles" in schema["required"]


def test_render_profiles_requires_night(schema):
    assert "night" in schema["properties"]["render_profiles"]["required"]


def test_night_requires_all_four_parameters(schema):
    required = set(schema["properties"]["render_profiles"]["properties"]["night"]["required"])
    assert set(NIGHT_KEYS) <= required


def test_tokens_json_validates_against_schema(validator, tokens):
    validator.validate(tokens)


def test_tokens_json_contains_canonical_night_parameters(tokens):
    night = tokens["render_profiles"]["night"]
    assert night["brightness_factor"] == 0.86
    assert night["saturation_factor"] == 0.72
    assert night["maximum_corrective_delta"] == 0.12
    assert night["corrective_step"] == 0.02


def test_missing_render_profiles_fails_validation(schema, tokens):
    broken = copy.deepcopy(tokens)
    del broken["render_profiles"]
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.Draft202012Validator(schema).validate(broken)


def test_night_without_night_profile_fails_validation(schema, tokens):
    broken = copy.deepcopy(tokens)
    del broken["render_profiles"]["night"]
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.Draft202012Validator(schema).validate(broken)


@pytest.mark.parametrize("key", NIGHT_KEYS)
def test_night_missing_parameter_fails_validation(schema, tokens, key):
    broken = copy.deepcopy(tokens)
    del broken["render_profiles"]["night"][key]
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.Draft202012Validator(schema).validate(broken)


def test_brightness_factor_must_be_in_open_unit_interval(schema, tokens):
    for bad in (0, 1.01):
        broken = copy.deepcopy(tokens)
        broken["render_profiles"]["night"]["brightness_factor"] = bad
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.Draft202012Validator(schema).validate(broken)


def test_saturation_factor_must_be_in_open_unit_interval(schema, tokens):
    for bad in (0, 1.5):
        broken = copy.deepcopy(tokens)
        broken["render_profiles"]["night"]["saturation_factor"] = bad
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.Draft202012Validator(schema).validate(broken)


def test_maximum_corrective_delta_bounds(schema, tokens):
    for bad in (-0.01, 0.21):
        broken = copy.deepcopy(tokens)
        broken["render_profiles"]["night"]["maximum_corrective_delta"] = bad
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.Draft202012Validator(schema).validate(broken)


def test_corrective_step_bounds(schema, tokens):
    for bad in (0, 0.25):
        broken = copy.deepcopy(tokens)
        broken["render_profiles"]["night"]["corrective_step"] = bad
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.Draft202012Validator(schema).validate(broken)


def test_corrective_step_must_not_exceed_maximum_corrective_delta(tokens):
    """Cross-field bound the schema cannot express: step (0, max_delta].

    The runtime loader (task 2.5) enforces the same invariant fail-closed.
    """
    night = tokens["render_profiles"]["night"]
    assert 0 < night["corrective_step"] <= night["maximum_corrective_delta"]
