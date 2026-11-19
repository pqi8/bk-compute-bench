# bk-compute-bench

The same 15 CI jobs (Rust, Go, Python, Java, Docker, Compose, Redis, Rails, Playwright, Bazel and
pi-mono's five CI jobs) run on three setups, each job on a fresh 4 vCPU machine, two at a time:

- Buildkite agents in throwaway Linux arm64 VMs on a Mac (`.buildkite/bench-mac.yml`)
- Buildkite hosted Linux Medium, amd64 (`.buildkite/bench-hosted.yml`)
- GitHub Actions `ubuntu-24.04` (x64) and `ubuntu-24.04-arm` (`.github/workflows/bench.yml`)

Every source is pinned to a tag or commit. Each job is `bench/<name>.sh`.
