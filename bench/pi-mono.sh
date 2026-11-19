#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
SUITE=${1:?suite}
mise use -g node@22
if [ "$SUITE" = coding-agent ] || [ "$SUITE" = other ]; then
  $SUDO apt-get update -qq && $SUDO apt-get install -y --no-install-recommends -qq fd-find ripgrep > /dev/null
  $SUDO ln -sf "$(command -v fdfind)" /usr/local/bin/fd
fi
fetch badlogic/pi-mono 1e34c3b4c7df78e716a8f53ad0bcf3a00feceedc pi-mono && cd pi-mono
npm ci --ignore-scripts
npm run build
case "$SUITE" in
  build) npm run check ;;
  other)
    if ! command -v cargo >/dev/null; then curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal; fi
    npm run build:daemon --workspace packages/env
    args=()
    for dir in packages/*/; do
      case "$dir" in packages/coding-agent/ | packages/durable/ | packages/chord/) continue ;; esac
      args+=(--workspace "${dir%/}")
    done
    npm run test:scripts
    npm run test --if-present "${args[@]}" ;;
  *) npm run test --workspace "packages/$SUITE" ;;
esac
