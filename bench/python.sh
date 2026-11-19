#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
fetch pallets/click 8.1.8 click && cd click
# Buildkite's hosted image has no ensurepip; install venv where it's missing (a no-op elsewhere).
python3 -c 'import ensurepip' 2>/dev/null || { $SUDO apt-get update -qq && $SUDO apt-get install -y -qq python3-venv > /dev/null; }
python3 -m venv .venv && . .venv/bin/activate
pip install --quiet --upgrade pip
# click 8.1.8 predates pytest 9.
pip install --quiet -e . "pytest<9"
pytest -q
