# Skill: Dev Containers & Reproducible Environments

## Objective
Ensure that development environments are not just "local setups" but reproducible artifacts defined as code. This eliminates "works on my machine" issues.

## Standards
1.  **Dockerfile:** Always base on a minimal, well-supported image (Arch/Alpine/Debian). Minimize layers.
2.  **Idempotency:** The `postCreateCommand` script must be safe to run multiple times.
3.  **User Mapping:** Ensure the container user (`remoteUser`) matches the host UID/GID where possible to avoid permission issues with bind mounts.
4.  **Features:** Use Dev Container Features (e.g., `ghcr.io/devcontainers/features/...`) instead of manual installation for common tools like Docker-in-Docker or AWS CLI.

## AI Instructions
When working on container configurations:
- Always check if a "Feature" exists before writing `RUN apt-get install`.
- Validate that the shell configuration persists across container rebuilds.
- Suggest defining `.devcontainer/devcontainer.json` for any project intended for collaboration.
