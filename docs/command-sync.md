# Slash Command Sync

Date: 2026-06-13

## Decision

AionUI and CCB-Wanding should expose a unified slash-command entry in the chat input.

The unified command list is not owned only by AionUI. Backend-executable commands are owned by CCB-Wanding and published through ACP `available_commands_update`. AionUI then supplements that list with UI-only commands.

## Source Of Truth

| Command kind | Owner | Notes |
| --- | --- | --- |
| Backend-executable commands | CCB-Wanding | Published through ACP. Examples: `/compact`, `/clear`, `/context`, `/env`, `/version`, Trellis commands. |
| UI-only commands | AionUI | Local renderer behavior only. Example: `/open`. |
| Commands requiring renderer UI contracts | Explicit mapping required | Do not expose blindly from backend unless AionUI knows how to render/execute the operation. |

## Backend Rule

CCB-Wanding ACP should publish headless-safe invocable commands:

- Include `prompt` commands.
- Include `local` commands when not hidden and not explicitly non-invocable.
- Exclude hidden commands.
- Exclude `userInvocable === false`.
- Exclude `local-jsx` until there is an explicit ACP/AionUI renderer mapping.

## Frontend Rule

AionUI should merge commands as:

1. Backend ACP commands first.
2. AionUI UI-only builtins second.
3. If IDs collide, backend wins.

This prevents AionUI local definitions from shadowing real backend commands such as `/btw` or `/copy`.

## Verified Live ACP Commands

A live `available_commands_update` from `D:\CCB-Wanding\dist\cli.js --acp` returned 42 commands after deployment:

```text
break-cache
clear
commit
commit-push-pr
compact
context
debug-tool-call
env
init
init-verifiers
insights
issue
keybindings
modo
perf-issue
poor
pr-comments
provider
recap
release-notes
reload-plugins
review
rewind
security-review
share
statusline
stickers
summary
trellis-before-dev
trellis-brainstorm
trellis-break-loop
trellis-check
trellis-meta
trellis-spec-bootstarp
trellis-update-spec
trellis:continue
trellis:finish-work
tui
version
vim
voice
workflows
```

## Follow-Up

Before release, manually verify in a fresh AionUI conversation:

- `/` shows backend commands plus AionUI UI-only commands.
- `/env` or `/version` executes through backend.
- `/open` still executes locally in AionUI.
- Existing quotation MCP flow still works.
