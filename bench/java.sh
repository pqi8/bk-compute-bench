#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
mise use -g java@temurin-21 maven@3.9
fetch google/gson gson-parent-2.11.0 gson && cd gson
mvn -B -q -Dmaven.javadoc.skip=true -pl gson -am verify
