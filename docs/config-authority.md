# AionUI / CCB-Wanding Config Authority

Date: 2026-06-13

## Decision

AionUI is the shell. CCB-Wanding is the runtime authority for capabilities and configuration that affect backend execution.

AionUI may provide UI for viewing or editing runtime configuration, but the authoritative runtime state must live in CCB-Wanding.

## Ownership

| Area | Authority | Notes |
| --- | --- | --- |
| Skills | CCB-Wanding | AionUI Skills UI should show CCB-Wanding configured skills. |
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

## Safety Rules

- CCB-owned MCP names are never overwritten: `quotation`, `accurate`, `excel-mcp`, `guide_mcp`, `aionui-image-generation`.
- Reserved and existing MCP name checks are case-insensitive.
- Skill folder names are sanitized before copy.
- CCB-Wanding conversations strip AionUI-local `skill_ids`, `disabled_builtin_skill_ids`, `mcp_ids`, `selected_mcp_server_ids`, and `selected_session_mcp_servers`.
- Agent switch and preset assistant creation paths must also apply the CCB runtime stripping rule.

## Verification

- `tests/unit/common-config/ccbConfigMigration.test.ts` passed: 10 tests.
- The migration export path is covered with a temp-directory test for `settings.json` backup, report writing, reserved MCP protection, imported MCP merge, and sanitized skill copy.
- `bunx tsc --noEmit --pretty false` passed.
- Manual release check: create a new CCB-Wanding conversation and confirm the create payload does not include AionUI legacy MCP/skill overrides.
- Quotation smoke should still use CCB-Wanding `settings.json` MCP, for example: `查询直接50价格`.
