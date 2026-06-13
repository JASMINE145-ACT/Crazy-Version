# Release Checklist

Use this checklist before deploying AionUI + CCB-Wanding to a server or distributing a new desktop build.

## 1. Source State

- Confirm AionUI source commit is recorded in `manifest.json`.
- Confirm CCB-Wanding source commit is recorded in `manifest.json`.
- Confirm installer/spec source commit is recorded in `manifest.json`.
- Confirm whether each component has pending local changes.
- Do not publish a release from untracked local changes unless the manifest explicitly records it.

## 2. Backend Build And Deploy

Run from CCB-Wanding source:

```powershell
cd D:\claude-code-B
bun run build
```

Deploy to Wanding runtime:

```powershell
$env:CCB_DEPLOY_ACK_NO_MCP='1'
& 'D:\Projects\claude-code-best\ccb-installer\scripts\deploy-claude-code-b-to-wanding.ps1' -Backup
```

Then sync Route-B:

```powershell
& 'D:\Projects\claude-code-best\ccb-installer\scripts\sync-aionui-ccb-route-b.ps1' -RestartAionUiWeb
```

## 3. Backend Smoke

Run:

```powershell
node D:\Projects\claude-code-best\ccb-installer\test-native-acp-agent.mjs
```

Expected:

- ACP initializes.
- Session starts.
- `available_commands_update` is received.
- Agent emits message chunks.
- Final stop reason is `end_turn`.

## 4. AionUI Slash Command Verification

In a fresh AionUI conversation:

- Type `/`.
- Confirm backend commands appear: `/compact`, `/clear`, `/context`, `/env`, `/version`.
- Confirm Trellis commands appear: `/trellis:continue`, `/trellis:finish-work`.
- Confirm UI-only commands still appear where expected: `/open`.
- Execute `/env` or `/version` and confirm backend execution.
- Execute `/open` and confirm AionUI local behavior.

## 5. MCP Business Flow Verification

In a fresh AionUI conversation, run a quotation flow such as:

```text
查询直接50价格
```

Expected:

- No `Tool not found`.
- Quotation MCP is available.
- AskUserQuestion renders correctly.
- Candidate selection continues the workflow.

## 6. AionUI Build Gate

Before packaging AionUI exe:

```powershell
cd D:\Projects\aionui-src
bunx tsc --noEmit --pretty false
```

Known blocker as of 2026-06-13:

- `MessageAcpPermission.tsx`: `reject_once` type mismatch.
- `MessageAcpPermission.tsx`: `AcpPermissionOption[]` cast warning.

Resolve these before final packaging.

## 7. Artifact Policy

- Prefer GitHub Releases or server artifact storage for exe, zip, and backend dist archives.
- Record artifact filename, checksum, source commit, and build time in the manifest or a release note.
- Do not commit large generated artifacts to normal git history without an explicit decision.
