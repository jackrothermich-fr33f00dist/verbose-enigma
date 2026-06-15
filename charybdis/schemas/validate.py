#!/usr/bin/env python3
"""Validate Charybdis pipeline example messages against their JSON Schemas.

Usage: python3 validate.py
Exits non-zero if any check fails.
"""
import copy
import json
import sys
from pathlib import Path

import jsonschema

SCHEMAS_DIR = Path(__file__).parent
EXAMPLES_DIR = SCHEMAS_DIR / "examples"

PAIRS = [
    ("whisperbot_handoff.schema.json", "whisperbot_handoff.valid.json"),
    ("whisperbot_result.schema.json", "whisperbot_result.valid.json"),
    ("processed_vault_manifest.schema.json", "processed_vault_manifest.valid.json"),
    ("sigilforge_request.schema.json", "sigilforge_request.valid.json"),
    ("sigilforge_receipt.schema.json", "sigilforge_receipt.valid.json"),
    ("orcavault_drop_receipt.schema.json", "orcavault_drop_receipt.valid.json"),
]


def load(path):
    with open(path) as f:
        return json.load(f)


def check_valid_examples():
    failures = []
    for schema_name, example_name in PAIRS:
        schema = load(SCHEMAS_DIR / schema_name)
        example = load(EXAMPLES_DIR / example_name)
        try:
            jsonschema.validate(example, schema)
            print(f"PASS  {example_name} validates against {schema_name}")
        except jsonschema.ValidationError as e:
            failures.append(f"{example_name} FAILED validation against {schema_name}: {e.message}")
    return failures


def check_negative_cases():
    failures = []

    # status: failed without error must be rejected
    schema = load(SCHEMAS_DIR / "whisperbot_result.schema.json")
    bad = load(EXAMPLES_DIR / "whisperbot_result.valid.json")
    bad = copy.deepcopy(bad)
    bad["status"] = "failed"
    del bad["error"]
    try:
        jsonschema.validate(bad, schema)
        failures.append("whisperbot_result: status=failed without 'error' should be rejected but passed")
    except jsonschema.ValidationError:
        print("PASS  whisperbot_result correctly rejects status=failed without 'error'")

    # bad sha256 pattern must be rejected
    schema = load(SCHEMAS_DIR / "sigilforge_receipt.schema.json")
    bad = copy.deepcopy(load(EXAMPLES_DIR / "sigilforge_receipt.valid.json"))
    bad["bundle"]["sha256"] = "not-a-hash"
    try:
        jsonschema.validate(bad, schema)
        failures.append("sigilforge_receipt: invalid sha256 should be rejected but passed")
    except jsonschema.ValidationError:
        print("PASS  sigilforge_receipt correctly rejects malformed sha256")

    # privileged + ready_for_encryption without reviewed_by must be rejected
    schema = load(SCHEMAS_DIR / "processed_vault_manifest.schema.json")
    bad = copy.deepcopy(load(EXAMPLES_DIR / "processed_vault_manifest.valid.json"))
    bad["event_metadata"]["sensitivity"] = "privileged"
    bad["review"]["ready_for_encryption"] = True
    try:
        jsonschema.validate(bad, schema)
        failures.append("processed_vault_manifest: privileged+ready_for_encryption without reviewed_by should be rejected but passed")
    except jsonschema.ValidationError:
        print("PASS  processed_vault_manifest correctly rejects unreviewed privileged record")

    return failures


def main():
    failures = check_valid_examples() + check_negative_cases()
    if failures:
        print("\nFAILURES:")
        for f in failures:
            print(f" - {f}")
        sys.exit(1)
    print("\nAll Charybdis schema checks passed.")


if __name__ == "__main__":
    main()
