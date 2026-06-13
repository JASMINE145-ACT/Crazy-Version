param(
    [string]$SourcePath = 'D:\claude-code-B'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "Backend source path not found: $SourcePath"
}

Push-Location $SourcePath
try {
    bun run build
}
finally {
    Pop-Location
}
