#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
mise use -g go@1.24
fetch spf13/cobra v1.8.1 cobra && cd cobra
go test -race ./...
