# Crazy-Version

Deployment control repository for the AionUI + CCB-Wanding stack.

This repository is intended to hold deployment orchestration, release manifests, verification notes, and server deployment scripts. It should not become a dumping ground for generated binaries or copied source trees.

## Scope

- AionUI desktop frontend / exe build coordination
- CCB-Wanding backend build and deployment coordination
- Route-B sync and ACP smoke verification
- Release manifests that pin source repositories, commits, build outputs, and checksums
- Operational documentation for server deployments

## Source Repositories

| Component | Source | Current Local HEAD |
| --- | --- | --- |
| AionUI frontend | https://github.com/iOfficeAI/AionUi.git | `762a8b0a73a7138aabab90a9c8538fec04361a3f` |
| CCB-Wanding backend | https://github.com/claude-code-best/claude-code.git | `91cffe16e23fc886f6860a7edfe8754d74a4abbf` |
| Installer / Trellis docs | https://github.com/JASMINE145-ACT/CCB-Iinstaller.git | `7626f6fbad0765f9efc36ad0299ed4a24fe3eaab` |

## Repository Policy

- Keep source changes in their original repositories.
- Track deployable versions through `manifest.json`.
- Put build/deploy/smoke scripts under `deploy/scripts/`.
- Put generated installers, zips, exe files, and backend dist archives in release storage or server artifact storage, not normal git history.
- Use `artifacts/` only as a local working directory; committed artifacts require an explicit release decision.

## Current Integration Note

The first tracked deployment concern is slash-command unification between AionUI and CCB-Wanding:

- CCB-Wanding is the source of truth for backend-executable slash commands.
- AionUI owns UI-only slash commands such as local file picker commands.
- AionUI should merge backend commands first, then supplement with UI-only local commands.
- Backend ACP should publish headless-safe commands via `available_commands_update`.

See `docs/command-sync.md` and `docs/release-checklist.md`.
