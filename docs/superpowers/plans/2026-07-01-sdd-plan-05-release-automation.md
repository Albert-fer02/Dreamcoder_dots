# SDD Plan 05: Release Automation & Engineering Excellence

> **Goal:** Automate EVERYTHING — tag → build → test → release → publish. No manual steps from commit to distribution.
> **Reference:** GoReleaser, PyPI trusted publishing, Dependabot, golangci-lint, commitlint
> **Target:** `.github/workflows/`, `installer/.goreleaser.yaml`, `.github/dependabot.yml`, `.github/CODEOWNERS`
> **Priority:** 🔴 HIGH — multiplies productivity
> **Estimated diff:** ~600 lines across 15+ files

## Philosophy

Un release no debería requerir más que un `git tag v2.1.0 && git push --tags`. Todo lo demás — compilar para 4 plataformas, publicar en PyPI, crear el GitHub Release, actualizar la Homebrew formula, generar el CHANGELOG — debería ser automático.

## Current State vs Target

| Feature                  | Hoy                        | Target                                   |
| ------------------------ | -------------------------- | ---------------------------------------- |
| **Go builds**            | `make build-all` manual    | GoReleaser automático en CI              |
| **Go tests**             | `go test` manual           | ✅ En cada push/PR                       |
| **Go lint**              | ❌ No existe               | golangci-lint en CI                      |
| **Python publish**       | ✅ CI on tags              | ✅ Ya funciona (trusted publishing)      |
| **Python tests**         | ✅ CI                      | ✅ Ya funciona                           |
| **Release creation**     | `gh release create` manual | GoReleaser + GitHub Release              |
| **Homebrew formula**     | `sha256` manual            | GoReleaser actualiza automático          |
| **Dependency updates**   | ❌ Manual                  | Dependabot semanal                       |
| **Changelog**            | Manual                     | Auto-generado desde conventional commits |
| **Issue/PR templates**   | ❌ No existe               | Templates en `.github/`                  |
| **Conventional commits** | ❌ No enforce              | commitlint en CI                         |
| **CODEOWNERS**           | ❌ No existe               | Para review routing                      |
| **Coverage reporting**   | ❌ Solo local              | Codecov / coveralls                      |

## Scope

### In Scope

**Release Pipeline (Go installer):**

- GoReleaser config (`.goreleaser.yaml`) para build cross-platform
- GitHub Actions release workflow: tag → build → test → release
- Auto-publish Homebrew formula con SHA256 actualizados
- Builds: linux/amd64, linux/arm64, darwin/amd64, darwin/arm64

**Quality Gates (CI):**

- Go build + test en cada push/PR
- golangci-lint en CI
- commitlint (conventional commits) en CI
- Code coverage upload to codecov.io

**Automation:**

- Dependabot for Go and Python dependencies
- Release Please for CHANGELOG auto-generation
- `.github/CODEOWNERS`

**Community:**

- Issue templates (bug report + feature request)
- PR template

### Out of Scope

- Semantic release for Python (PyPI publish already works)
- SBOM generation (future concern)
- Performance benchmarks (Plan 06 candidate)
- Docker E2E (separate concern)

## Architecture

### Trigger Flow

```
git tag v2.1.0
  │
  ▼
GitHub Actions: Release Workflow
  ├── GoReleaser
  │   ├── build linux/amd64
  │   ├── build linux/arm64
  │   ├── build darwin/amd64
  │   ├── build darwin/arm64
  │   ├── create GitHub Release
  │   └── publish Homebrew formula
  ├── Python publish (to PyPI via trusted publishing)
  │
  └── (already exists) ✅
```

### CI Flow (every push/PR)

```
Push/PR to main
  │
  ▼
GitHub Actions: CI Workflow
  ├── Python (3.11, 3.12)
  │   ├── ruff lint + format
  │   ├── mypy type check
  │   ├── pytest + coverage
  │   ├── shellcheck
  │   └── theme health check
  ├── Go
  │   ├── go build
  │   ├── go test ./...
  │   └── golangci-lint
  ├── commitlint
  │   └── conventional commits check
  └── Upload coverage to codecov
```

## Files to Create/Modify

### New Files

| File                                         | Purpose                           |
| -------------------------------------------- | --------------------------------- |
| `.github/workflows/ci-go.yml`                | Go build + test + lint on push/PR |
| `.github/workflows/release.yml`              | GoReleaser + PyPI publish on tag  |
| `.goreleaser.yaml`                           | GoReleaser configuration          |
| `.github/dependabot.yml`                     | Auto-dependency updates           |
| `.github/CODEOWNERS`                         | Code review routing               |
| `.github/ISSUE_TEMPLATE/bug_report.yml`      | Bug report form                   |
| `.github/ISSUE_TEMPLATE/feature_request.yml` | Feature request form              |
| `.github/PULL_REQUEST_TEMPLATE.md`           | PR template                       |
| `.github/workflows/commitlint.yml`           | Conventional commits check        |
| `commitlint.config.js`                       | Commitlint rules                  |

### Modified Files

| File                                     | Change                                 |
| ---------------------------------------- | -------------------------------------- |
| `.github/workflows/theme-validation.yml` | Add Go matrix, add codecov upload      |
| `.pre-commit-config.yaml`                | Add commitlint hook                    |
| `Makefile`                               | Simplify (GoReleaser handles builds)   |
| `installer/go.mod`                       | May need updates for GoReleaser compat |

## Acceptance Criteria

1. `git tag v2.1.0 && git push --tags` → CI builds for 4 platforms, creates GitHub Release, publishes PyPI
2. Every push/PR → Go build + test passes
3. `golangci-lint` passes with zero issues
4. `commitlint` enforces conventional commits on every PR
5. Dependabot opens weekly PRs for outdated deps
6. Issue templates appear when creating new issues
7. PR template appears when creating new PRs
8. Coverage is uploaded to codecov.io with badge in README

## Tasks

### Task 1: GoReleaser Configuration

- Create `.goreleaser.yaml` with:
  - 4 builds (linux/amd64, linux/arm64, darwin/amd64, darwin/arm64)
  - Version injected via ldflags: `-X github.com/dreamcoder08/dreamcoder-dots/installer/pkg/version.Version={{ .Version }}`
  - Homebrew tap publish: `brews:` section pointing to `homebrew-tap/Formula/dreamcoder-dots.rb`
  - Archive config (tar.gz for linux, zip for darwin)
  - Release notes auto-generated from git log

### Task 2: Release Workflow

- Create `.github/workflows/release.yml`:

  ```yaml
  name: Release
  on:
    push:
      tags: ['v*']
  jobs:
    goreleaser:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
          with:
            fetch-depth: 0
        - uses: actions/setup-go@v5
          with:
            go-version: stable
        - uses: goreleaser/goreleaser-action@v6
          with:
            version: '~> v2'
            args: release --clean
          env:
            GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    publish-pypi:
      needs: [goreleaser]
      # Uses existing PyPI publish job
  ```

### Task 3: Go CI (every push/PR)

- Create `.github/workflows/ci-go.yml`:

  ```yaml
  name: CI (Go)
  on: [push, pull_request]
  jobs:
    go:
      strategy:
        matrix:
          go-version: ['1.26', '1.27']
      steps:
        - uses: actions/checkout@v4
        - uses: actions/setup-go@v5
        - run: go build ./...
        - run: go test ./...
        - uses: golangci/golangci-lint-action@v6
  ```

### Task 4: Quality Gates

- Create `commitlint.config.js`:

  ```js
  module.exports = {
    extends: ['@commitlint/config-conventional'],
    rules: {
      'type-enum': [
        2,
        'always',
        [
          'feat',
          'fix',
          'docs',
          'style',
          'refactor',
          'perf',
          'test',
          'chore',
          'ci',
          'build',
        ],
      ],
    },
  }
  ```

- Create `.github/workflows/commitlint.yml`
- Update `.pre-commit-config.yaml` to add commitlint hook

### Task 5: Dependabot

- Create `.github/dependabot.yml`:

  ```yaml
  version: 2
  updates:
    - package-ecosystem: 'gomod'
      directory: '/installer'
      schedule:
        interval: 'weekly'
    - package-ecosystem: 'pip'
      directory: '/'
      schedule:
        interval: 'weekly'
    - package-ecosystem: 'github-actions'
      directory: '/'
      schedule:
        interval: 'weekly'
  ```

### Task 6: CODEOWNERS

- Create `.github/CODEOWNERS`:

  ```
  * @Dreamcoder08
  src/dreamcoder_theme/ @Dreamcoder08
  installer/ @Dreamcoder08
  .github/ @Dreamcoder08
  ```

### Task 7: Community Templates

- Create `.github/ISSUE_TEMPLATE/bug_report.yml`
- Create `.github/ISSUE_TEMPLATE/feature_request.yml`
- Create `.github/PULL_REQUEST_TEMPLATE.md`
- Add config.yml for issue forms

### Task 8: Coverage Reporting

- Add `codecov-action` to CI workflow
- Add coverage badge to README.md
- Configure `codecov.yml` with threshold

### Task 9: Merge Into Existing CI

- Update `.github/workflows/theme-validation.yml` (rename to `ci-python.yml`)
- Add Go matrix to existing workflow or keep separate
- Ensure all workflows run in parallel
- Add `codecov` upload step

## Risks

- **GoReleaser version**: GoReleaser v2 has breaking changes from v1 — pin version in action
- **Homebrew formula update**: GoReleaser's `brews` config needs the formula file to exist with template markers
- **commitlint**: Requires Node.js in CI — adds ~30s to workflow
- **Secret management**: PyPI trusted publishing requires OIDC — already configured ✅
- **Go version matrix**: `go 1.26.4` in `go.mod` — verify CI runners support it

## References

- GoReleaser docs: <https://goreleaser.com>
- GoReleaser GitHub Action: <https://github.com/goreleaser/goreleaser-action>
- PyPI trusted publishing: <https://docs.pypi.org/trusted-publishers/>
- Dependabot config: <https://docs.github.com/en/code-security/dependabot>
- Commitlint: <https://commitlint.js.org/>
- Current CI: `.github/workflows/theme-validation.yml`
- Current Makefile: `installer/Makefile`
- Current pyproject.toml: `pyproject.toml`
- Current Homebrew formula: `homebrew-tap/Formula/dreamcoder-dots.rb`
