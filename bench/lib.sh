# Shared setup for every benchmark job. Works on bk-compute VMs (non-root, mise baked in),
# Buildkite hosted (root, mise baked in) and GitHub Actions (non-root, no mise).

# Buildkite hosted runs jobs as root, so tests that expect a permission error (cobra's read-only
# file write, pi-mono's file-permission tests) fail there. Re-run the job as an unprivileged user
# with passwordless sudo, the same way the Mac VMs and GitHub runners run it.
if [ "$(id -u)" = 0 ] && [ -z "${BENCH_REEXEC:-}" ]; then
  command -v sudo >/dev/null || { apt-get update -qq && apt-get install -y -qq sudo >/dev/null; }
  id bench >/dev/null 2>&1 || useradd -m -s /bin/bash bench
  echo 'bench ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/bench && chmod 440 /etc/sudoers.d/bench
  if getent group docker >/dev/null; then usermod -aG docker bench; fi
  if [ -S /var/run/docker.sock ]; then chmod 666 /var/run/docker.sock; fi
  # Keep using the image's preinstalled mise data, as the root runs did.
  for d in "${MISE_DATA_DIR:-}" "${MISE_CACHE_DIR:-}" "${MISE_STATE_DIR:-}" "${MISE_CONFIG_DIR:-}"; do
    if [ -n "$d" ] && [ -d "$d" ]; then chown -R bench "$d"; fi
  done
  chmod -R a+rwX "$PWD"
  echo "bench: running as user bench instead of root"
  exec sudo -E -H -u bench env -u TMPDIR "PATH=$PATH" BENCH_REEXEC=1 bash "$0" "$@"
fi

set -euo pipefail
SUDO=$(command -v sudo || true)
# A stalled apt mirror connection added up to 7 minutes to some Playwright runs on the amd64
# setups. Time out a stalled download and retry it instead of waiting.
printf 'Acquire::http::Timeout "15";\nAcquire::https::Timeout "15";\nAcquire::Retries "3";\n' \
  | $SUDO tee /etc/apt/apt.conf.d/99bench >/dev/null
if ! command -v mise >/dev/null; then curl -fsSL https://mise.run | sh; fi
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$HOME/.cargo/bin:$PATH"
export MISE_YES=1
WORK=$(mktemp -d "${TMPDIR:-/tmp}/bench.XXXXXX")
cd "$WORK"
# Shallow clone of one exact ref (tag or commit).
fetch() { git init -q "$3" && git -C "$3" fetch -q --depth 1 "https://github.com/$1.git" "$2" && git -C "$3" checkout -q FETCH_HEAD; }
# Run a mise-installed tool as root. mise's shims resolve per user, so put the tool's real
# bin directory first: asroot node npx playwright install-deps
asroot() { local bin; bin=$(dirname "$(mise which "$1")"); shift
  if [ -n "$SUDO" ]; then $SUDO env "PATH=$bin:$PATH" "$@"; else PATH="$bin:$PATH" "$@"; fi; }
echo "bench host: $(uname -m) $(nproc) vCPU $(free -g | awk '/Mem/{print $2}') GB, user $(id -un)"
