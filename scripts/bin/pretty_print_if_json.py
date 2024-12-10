#!/usr/bin/env python3

import json
import sys


def pretty_print_json_or_as_is(input_data):
    try:
        # Try to parse the input as JSON
        parsed_json = json.loads(input_data)
        # If parsing succeeds, pretty print the JSON
        print(json.dumps(parsed_json, indent=4))
    except (json.JSONDecodeError, TypeError):
        # If parsing fails, print the input as it is
        print(input_data.strip())


if __name__ == "__main__":
    # Read input lines from stdin
    for line in sys.stdin:
        pretty_print_json_or_as_is(line)
