# Skill: Security & Privacy (Government Grade)

## Objective
Ensure all code meets the stability and security requirements for ProInnóvate Perú and SUNAT-related integrations.

## Principles
1. **Assume Malicious Input:** All data from external APIs or users must be validated.
2. **Privacy by Design:** Mask PII (Email, Phone, ID) in logs. No secrets in source code.
3. **Audit Trails:** Implement strict logging for all sensitive business actions.
4. **Least Privilege:** Applications should only have the permissions necessary to function.

## Security Audit Checklist
- Check for SQL Injection (use Parameterized Queries).
- Check for XSS in UI rendering.
- Verify JWT/Auth token expiration and security.
- Identify hardcoded API keys.

## AI Instructions
- Before finalizing a feature, run a mental "Security Audit".
- If a proposed change touches PII, warn the user and suggest masking/encryption.
- Prioritize auditability in database schemas.
