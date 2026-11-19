# Shared setup for every benchmark job. Works on bk-compute VMs (non-root, mise baked in),
# Buildkite hosted (root, mise baked in) and GitHub Actions (non-root, no mise).
set -euo pipefail
SUDO=$(command -v sudo || true)
if ! command -v mise >/dev/null; then curl -fsSL https://mise.run | sh; fi
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$HOME/.cargo/bin:$PATH"
export MISE_YES=1
WORK=$(mktemp -d "${TMPDIR:-/tmp}/bench.XXXXXX")
cd "$WORK"
# Shallow clone of one exact ref (tag or commit).
fetch() { git init -q "$3" && git -C "$3" fetch -q --depth 1 "https://github.com/$1.git" "$2" && git -C "$3" checkout -q FETCH_HEAD; }
# Run a mise-installed tool as root (mise shims resolve per user).
asroot() { if [ -n "$SUDO" ]; then $SUDO env "PATH=$PATH" "$@"; else "$@"; fi; }
echo "bench host: $(uname -m) $(nproc) vCPU $(free -g | awk '/Mem/{print $2}') GB, user $(id -un)"
