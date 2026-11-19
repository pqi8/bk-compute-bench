#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
if ! command -v rustup >/dev/null; then curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain none; fi
# ripgrep 14.1.1's integration tests find `rg` relative to the test binary, which newer
# Cargo releases moved; pin a toolchain from that era everywhere.
rustup toolchain install --profile minimal 1.85.0
export RUSTUP_TOOLCHAIN=1.85.0
fetch BurntSushi/ripgrep 14.1.1 rg && cd rg
cargo build --release --locked
cargo test --release --locked
