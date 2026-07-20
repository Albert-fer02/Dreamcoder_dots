# OpenAI OAuth Preflight Guard

Before delegating or applying work that uses the native OpenAI provider (or any provider configured under `provider.openai` in your `opencode.json`), perform the following preflight check:

1. **Safe Provider-Status Check**: Run `opencode providers list` and verify the OpenAI provider entry shows an authenticated/connected status or an `active` OAuth session. Use only the CLI's built-in read output — do NOT parse environment variables, credential files, or configuration values.

2. **Validate Native OpenAI Model IDs**: Before delegating to any sub-agent configured with a native OpenAI model (a model ID beginning with `openai/`), validate that model ID against the runtime's supported model metadata. Use `opencode providers list` or another read-only CLI command to check whether each `openai/...` model ID corresponds to a known supported model for the active provider. If validation cannot establish that the model is supported — the ID is unrecognized, the provider does not list it, or the CLI exposes no mechanism to verify support — STOP and ask the user to confirm or correct the model ID. Do not proceed, fall back, or silently substitute an unresolvable model. Never parse, export, or inject credentials during this check.

3. **Stop on Unavailable**: If the OpenAI OAuth provider status indicates no active session, authentication failure, or connection error, STOP immediately. Do not attempt to fall back to other providers, retry the check, or work around the missing auth. Inform the user that OpenAI OAuth is unavailable and direct them to run `opencode /connect` to re-authenticate.

4. **Never Handle Secrets**: Under no circumstances should you:
   - Parse, export, log, or display any access token, API key, or credential
   - Inject credentials into environment variables
   - Read or modify provider configuration values, API keys, or tokens in `opencode.json` or any secrets file
   - Attempt to work around or bypass the OAuth flow

This guard applies to the native OpenAI provider specifically. Other providers are unaffected by this check.
