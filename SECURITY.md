# Security

Security rules for Dreamcoder Workbench.

## Secrets

Never commit secrets to this repo.

Do not commit:

- GitHub PATs
- OpenAI keys
- `auth.json`
- `.env` files
- `~/.codex/` runtime data
- session logs
- MCP tokens

## GitHub MCP token

GitHub MCP uses a private token file:

```txt
~/.config/github/pat
```

Expected permissions:

```txt
0600
```

The private wrapper is:

```txt
~/.local/bin/github-mcp-dreamcoder
```

It reads the token and launches the official GitHub MCP server. This keeps the
token out of the repo and avoids depending on Codex inheriting environment
variables.

If a token is pasted into chat, rotate it in GitHub and replace the private
file.

## Dotfiles safety

- Use symlinks/stow for configs.
- Keep runtime data out of the repo.
- Keep scripts small and auditable.
- Prefer private files under `~/.config/...` for credentials.

## Shell script rules

Follow `AGENTS.md`:

- scripts should use `set -euo pipefail`
- quote variables
- use safe sourcing
- keep scripts focused and short
- avoid hardcoded secrets

## Validation

Useful checks:

```bash
bash -n scripts/update-colors.sh
python3 -m py_compile scripts/sync-dreamcoder-theme.py
ghostty +validate-config
STARSHIP_CONFIG=DreamcoderShell/.config/starship.toml starship explain
fish -n DreamcoderShell/.config/fish/config.fish
```
