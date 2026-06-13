# AionUI / CCB-Wanding Config Authority

Date: 2026-06-13

## Decision

AionUI is the shell. CCB-Wanding is the runtime authority for capabilities and configuration that affect backend execution.

AionUI may provide UI for viewing or editing runtime configuration, but the authoritative runtime state must live in CCB-Wanding.

## Ownership

| Area | Authority | Notes |
| --- | --- | --- |
| Skills | CCB-Wanding | AionUI Skills UI shows and edits CCB-Wanding user skills. |
| MCP servers/tools | CCB-Wanding | AionUI MCP UI should show CCB-Wanding configured MCP and status. |
| Assistant templates that affect runtime | CCB-Wanding | AionUI can keep the template UI, but template persistence/application should move to CCB-Wanding. |
| Slash commands/capabilities | CCB-Wanding | AionUI renders and forwards; CCB-Wanding owns command semantics. |
| Theme/language/window/font/notifications | AionUI | Shell-only user experience settings. |
| File picker/drag upload | AionUI | Shell-only interaction. |

## Migration Behavior

AionUI performs a one-shot migration when CCB-Wanding is installed:

- Exports AionUI MCP entries into `%LOCALAPPDATA%\CCB-Wanding\.claude\settings.json`.
- Copies user skills into `%LOCALAPPDATA%\CCB-Wanding\.claude\skills\` when the source path is available.
- Writes a backup before modifying `settings.json`.
- Writes `%LOCALAPPDATA%\CCB-Wanding\.claude\aionui-migration-report.json`.
- Does not set the completion flag if CCB-Wanding is not installed, so the migration can run later.

## Skills Authority Implementation

- CCB-Wanding now has a testable skills manifest generator in `src/services/acp/skillsManifest.ts` based on the existing `getSkillToolCommands(cwd)` loader.
- AionUI now uses a CCB-backed Skills adapter in `packages/desktop/src/common/config/ccbSkills.ts`.
- AionUI Skills Hub lists directories under `%LOCALAPPDATA%\CCB-Wanding\.claude\skills`.
- Import copies skill directories into the CCB-Wanding skills directory with sanitized folder names.
- Delete removes the matching CCB-Wanding skill directory, so new CCB sessions do not load it.
- Legacy AionUI Skills Hub data is migration/read-only input, not runtime authority for CCB sessions.

## Safety Rules

- CCB-owned MCP names are never overwritten: `quotation`, `accurate`, `excel-mcp`, `guide_mcp`, `aionui-image-generation`.
- Reserved and existing MCP name checks are case-insensitive.
- Skill folder names are sanitized before copy.
- CCB-Wanding conversations strip AionUI-local `skill_ids`, `disabled_builtin_skill_ids`, `mcp_ids`, `selected_mcp_server_ids`, and `selected_session_mcp_servers`.
- Agent switch and preset assistant creation paths must also apply the CCB runtime stripping rule.

## Verification

- `tests/unit/common-config/ccbConfigMigration.test.ts` passed: 10 tests.
- `tests/unit/common-config/ccbSkills.test.ts` passed: CCB skills import/list/delete adapter.
- `src/services/acp/__tests__/skillsManifest.test.ts` passed: CCB skills manifest generator.
- The migration export path is covered with a temp-directory test for `settings.json` backup, report writing, reserved MCP protection, imported MCP merge, and sanitized skill copy.
- `bunx tsc --noEmit --pretty false` passed in AionUI.
- Backend targeted skills/capabilities unit tests passed. Full backend typecheck is currently blocked by sibling MCP authority work in `src/cli/handlers/ccbMcpManifest.ts`.
- Manual release check: create a new CCB-Wanding conversation and confirm the create payload does not include AionUI legacy MCP/skill overrides.
- Quotation smoke should still use CCB-Wanding `settings.json` MCP, for example: `查询直接50价格`.

## Remaining Boundary

File-backed CCB user skills are wired into AionUI. A dedicated ACP/HTTP endpoint for a complete manifest of bundled/plugin/project/MCP skills remains future work.
