# Publishing dreamcoder-theme to PyPI

← Back to [docs/README.md](README.md)

The release workflow builds the Python package as an artifact but does NOT
automatically publish to PyPI yet, because it requires a Trusted Publisher
to be configured on PyPI's end.

## One-time setup: Configure Trusted Publisher

1. Go to <https://pypi.org/manage/project/dreamcoder-theme/settings/publishing/>
2. Add a new trusted publisher:
   - **PyPI Project**: `dreamcoder-theme`
   - **Publisher**: `GitHub`
   - **Owner**: `Dreamcoder08`
   - **Repository**: `Dreamcoder_dots`
   - **Workflow**: `release.yml`
   - **Environment**: (leave empty)

3. Once configured, the `publish-pypi` job in `.github/workflows/release.yml`
   will automatically publish to PyPI on every `v*` tag push.

## Manual publish (without Trusted Publisher)

```bash
# Build
pip install build
python -m build

# Upload manually
pip install twine
twine upload dist/*
```

## Required secrets

No secrets needed — PyPI's Trusted Publisher uses OIDC (OpenID Connect)
which authenticates directly via GitHub's OIDC token. Just configure
the publisher on PyPI and it works.
