# Generates .ai/context-snapshot.md as the AI-first quick recovery entry.
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'read-project.ps1')

$project = Get-ProjectMetadata -Root $root
$name = if ($project.name) { $project.name } else { 'unknown' }
$version = if ($project.version) { $project.version } else { 'unknown' }
$profile = if ($project.language_profile) { $project.language_profile } else { 'unknown' }
$toolchain = if ($project.toolchain) { $project.toolchain } else { 'unknown' }

$branch = 'unknown'
$commit = 'unknown'
$gitFiles = 'no git repository'
if (Test-Path (Join-Path $root '.git')) {
    $branch = (git -C $root rev-parse --abbrev-ref HEAD 2>$null | Out-String).Trim()
    $commit = (git -C $root rev-parse --short HEAD 2>$null | Out-String).Trim()
    if (-not $branch) { $branch = 'unknown' }
    if (-not $commit) { $commit = 'unknown' }
    $changed = @(git -C $root status --short 2>$null | Select-Object -First 10)
    if ($changed.Count -gt 0) { $gitFiles = ($changed -join '; ') } else { $gitFiles = 'clean' }
}
$lastUpdate = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')

function Get-StatusSection {
    param([string]$Path, [int]$Index)

    if (-not (Test-Path $Path)) { return 'none' }
    $lines = @(Get-Content $Path -Encoding UTF8)
    $headings = @()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^##\s') { $headings += $i }
    }
    if ($Index -ge $headings.Count) { return 'none' }

    $start = $headings[$Index] + 1
    $end = if ($Index + 1 -lt $headings.Count) { $headings[$Index + 1] } else { $lines.Count }
    $items = @($lines[$start..($end - 1)] | Where-Object { $_.Trim() -and $_ -notmatch '^#' } | ForEach-Object { $_.Trim() } | Select-Object -First 5)
    if ($items.Count -eq 0) { return 'none' }
    return ($items -join '; ')
}

function Get-TaskLogRecent {
    param([string]$Path, [int]$Count)

    if (-not (Test-Path $Path)) { return 'none' }
    $rows = @(Get-Content $Path -Encoding UTF8 | Where-Object { $_ -match '^\| \d{4}-' })
    if ($rows.Count -eq 0) { return 'none' }
    return (($rows | Select-Object -Last $Count) -join ' || ')
}

function Get-DecisionRecent {
    param([string]$Path, [int]$Count)

    if (-not (Test-Path $Path)) { return 'none' }
    $rows = @(Get-Content $Path -Encoding UTF8 | Where-Object { $_ -match '^\| \d{4}' })
    if ($rows.Count -eq 0) { return 'none' }
    return (($rows | Select-Object -Last $Count | ForEach-Object { ($_ -replace '^\|\s*', '').Trim() }) -join '; ')
}

$milestone = Get-StatusSection -Path (Join-Path $root '.ai\status.md') -Index 0
$completed = Get-StatusSection -Path (Join-Path $root '.ai\status.md') -Index 1
$current = Get-StatusSection -Path (Join-Path $root '.ai\status.md') -Index 2
$blocked = Get-StatusSection -Path (Join-Path $root '.ai\status.md') -Index 3
$next = Get-StatusSection -Path (Join-Path $root '.ai\status.md') -Index 4
$recent = Get-TaskLogRecent -Path (Join-Path $root '.ai\task-log.md') -Count 2
$decisions = Get-DecisionRecent -Path (Join-Path $root 'docs\decisions\README.md') -Count 3

$labelProjectName = "$([char]0x9879)$([char]0x76EE)$([char]0x540D)$([char]0x79F0)"
$labelCurrentVersion = "$([char]0x5F53)$([char]0x524D)$([char]0x7248)$([char]0x672C)"
$labelDevEnv = "$([char]0x5F00)$([char]0x53D1)$([char]0x73AF)$([char]0x5883)"
$labelToolchain = "$([char]0x5DE5)$([char]0x5177)$([char]0x94FE)"

$content = @"
# Project

- ${labelProjectName}: $name
- ${labelCurrentVersion}: $version

# Environment

- ${labelDevEnv}: $profile
- ${labelToolchain}: $toolchain

# Git Status

- Branch: $branch
- Commit: $commit
- Last Update: $lastUpdate

# Current Milestone

$milestone

# Completed Tasks

$completed

# Current Tasks

$current

# Blocked Issues

$blocked

# Recent Changes

$recent

# Important Decisions

$decisions

# Files Changed Recently

$gitFiles

# Next Actions

$next

# AI Instructions

- Read AGENTS.md first, then this snapshot and .ai/status.md.
- Keep long-term design details in docs/, not here.
- Refresh this file with scripts/ai-context-update.ps1 at session end.
- Follow .ai/prompts/_checklist.md when closing a session.
"@

$snapshot = Join-Path $root '.ai\context-snapshot.md'
Set-Content -Path $snapshot -Value $content -Encoding UTF8
Write-Host "Snapshot updated: $snapshot"
