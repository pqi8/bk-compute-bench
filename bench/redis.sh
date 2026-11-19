#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
$SUDO apt-get update -qq && $SUDO apt-get install -y -qq tcl > /dev/null
fetch redis/redis 7.4.2 redis && cd redis
make -j"$(nproc)" BUILD_TLS=no > build.log 2>&1 || { tail -40 build.log; exit 1; }
./runtest --single unit/type/string --single unit/type/list --clients 4
