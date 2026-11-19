#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
fetch pallets/click 8.1.8 click && cd click
python3 -m venv .venv && . .venv/bin/activate
pip install --quiet --upgrade pip
pip install --quiet -e . pytest
pytest -q
