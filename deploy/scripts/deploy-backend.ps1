param(
    [string]$InstallerRepoPath = 'D:\Projects\claude-code-best',
    [switch]$Backup
)

$ErrorActionPreference = 'Stop'

$script = Join-Path $InstallerRepoPath 'ccb-installer\scripts\deploy-claude-code-b-to-wanding.ps1'
if (-not (Test-Path -LiteralPath $script)) {
    throw "Deploy script not found: $script"
}

$env:CCB_DEPLOY_ACK_NO_MCP = '1'

if ($Backup) {
    & $script -Backup
} else {
    & $script
}

exit $LASTEXITCODE
