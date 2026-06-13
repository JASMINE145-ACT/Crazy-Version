param(
    [string]$InstallerRepoPath = 'D:\Projects\claude-code-best'
)

$ErrorActionPreference = 'Stop'

$script = Join-Path $InstallerRepoPath 'ccb-installer\test-native-acp-agent.mjs'
if (-not (Test-Path -LiteralPath $script)) {
    throw "ACP smoke script not found: $script"
}

node $script
exit $LASTEXITCODE
