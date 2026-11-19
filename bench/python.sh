#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
fetch pallets/click 8.1.8 click && cd click
python3 -m venv .venv && . .venv/bin/activate
pip install --quiet --upgrade pip
# click 8.1.8 predates pytest 9.
pip install --quiet -e . "pytest<9"
pytest -q
