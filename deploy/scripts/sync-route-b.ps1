param(
    [string]$InstallerRepoPath = 'D:\Projects\claude-code-best',
    [switch]$RestartAionUiWeb
)

$ErrorActionPreference = 'Stop'

$script = Join-Path $InstallerRepoPath 'ccb-installer\scripts\sync-aionui-ccb-route-b.ps1'
if (-not (Test-Path -LiteralPath $script)) {
    throw "Route-B sync script not found: $script"
}

if ($RestartAionUiWeb) {
    & $script -RestartAionUiWeb
} else {
    & $script
}

exit $LASTEXITCODE
