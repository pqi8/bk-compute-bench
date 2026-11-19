#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
mise use -g bazelisk
fetch bazelbuild/examples efab5bd4660ebfe720bd52efaeeccefaf00ee4ad examples && cd examples/cpp-tutorial/stage3
bazelisk build //main:hello-world
bazelisk run //main:hello-world
