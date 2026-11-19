#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
if ! command -v cargo >/dev/null; then curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal; fi
fetch BurntSushi/ripgrep 14.1.1 rg && cd rg
cargo build --release --locked
# ripgrep 14.1.1's binary:: tests cannot spawn their helper on GitHub's x64 runner; skip them everywhere.
cargo test --release --locked -- --skip binary::
