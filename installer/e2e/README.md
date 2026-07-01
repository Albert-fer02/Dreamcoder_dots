# Docker E2E Testing for dreamcoder-dots installer

Tests the Go TUI installer across multiple Linux distributions
using Docker containers.

## Quick Start

```bash
cd installer/e2e
bash docker-test.sh
```

This builds and tests the installer on:

- Ubuntu 24.04
- Debian 12
- Fedora 40
- Alpine 3.20

## Test Scenarios

Each container runs:

1. `go build` — compile the installer
2. `./dreamcoder-dots --version` — binary runs
3. `./dreamcoder-dots doctor` — platform detection works
4. `./dreamcoder-dots install --dry-run` — install logic works

## Adding a distro

```bash
cp Dockerfile.ubuntu Dockerfile.<distro>
# Edit the FROM line and package manager
# Add to docker-test.sh
```

## Prerequisites

- Docker Engine 24+
- Bash

## CI Integration

This is designed to run as a GitHub Actions matrix job.
See `.github/workflows/ci-go.yml` for the current Go test setup.
