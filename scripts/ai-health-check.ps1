# Checks AI knowledge base consistency. Exit code 0 = no failures; 1 = failures found.
param(
    [int]$MaxAgeDays = 7
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'read-project.ps1')

$failures = 0
$warnings = 0

function Write-Check {
    param([string]$Name, [bool]$Ok, [string]$Detail = '')
    $tag = if ($Ok) { 'PASS' } else { 'WARN' }
    if (-not $Ok) { $script:warnings++ }
    Write-Host ("[{0}] {1} {2}" -f $tag, $Name, $Detail)
}

function Write-Fail {
    param([string]$Name, [string]$Detail = '')
    $script:failures++
    Write-Host ("[FAIL] {0} {1}" -f $Name, $Detail)
}

$projectFile = Join-Path $root 'config\project.yaml'
if (Test-Path $projectFile) {
    $project = Get-ProjectMetadata -Root $root
    Write-Check -Name 'project.yaml' -Ok $true
    Write-Check -Name 'project.name' -Ok ([bool]$project.name) -Detail $project.name
    Write-Check -Name 'project.language_profile' -Ok ($project.language_profile -notin @('', 'TBD')) -Detail $project.language_profile
    Write-Check -Name 'project.version' -Ok ([bool]$project.version) -Detail $project.version
} else {
    Write-Fail -Name 'project.yaml' -Detail 'missing'
}

$snapshot = Join-Path $root '.ai\context-snapshot.md'
if (Test-Path $snapshot) {
    $text = Get-Content $snapshot -Raw
    $match = [regex]::Match($text, 'Last Update: (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})')
    if ($match.Success) {
        $stamp = [datetime]::ParseExact($match.Groups[1].Value, 'yyyy-MM-dd HH:mm:ss', $null)
        $age = ((Get-Date) - $stamp).Days
        Write-Check -Name 'snapshot freshness' -Ok ($age -le $MaxAgeDays) -Detail ("last update {0} day(s) ago" -f $age)
    } else {
        Write-Check -Name 'snapshot freshness' -Ok $false -Detail 'missing Last Update field'
    }
} else {
    Write-Check -Name 'snapshot' -Ok $false -Detail 'missing; run scripts/ai-context-update.ps1'
}

$taskLog = Join-Path $root '.ai\task-log.md'
if (Test-Path $taskLog) {
    $lines = @(Get-Content $taskLog | Where-Object { $_ -match '^\| \d{4}-' })
    Write-Check -Name 'task-log entries' -Ok ($lines.Count -gt 0) -Detail ("{0} row(s)" -f $lines.Count)
} else {
    Write-Check -Name 'task-log' -Ok $false -Detail 'missing'
}

$handoff = Join-Path $root '.ai\handoff.md'
Write-Check -Name 'handoff' -Ok (Test-Path $handoff) -Detail $(if (Test-Path $handoff) { 'ok' } else { 'missing' })

foreach ($reportName in @('build', 'test')) {
    $reportFile = Join-Path $root ("build\last-{0}.json" -f $reportName)
    if (Test-Path $reportFile) {
        $report = Get-Content $reportFile -Raw | ConvertFrom-Json
        Write-Check -Name ("report.{0}" -f $reportName) -Ok ($report.status -in @('passed', 'failed')) -Detail $report.status
    } else {
        Write-Check -Name ("report.{0}" -f $reportName) -Ok $false -Detail 'missing; run scripts/build.ps1'
    }
}

$specIndex = Join-Path $root 'spec\INDEX.md'
Write-Check -Name 'spec index' -Ok (Test-Path $specIndex) -Detail $(if (Test-Path $specIndex) { 'ok' } else { 'missing' })

$adrReadme = Join-Path $root 'docs\decisions\README.md'
Write-Check -Name 'adr readme' -Ok (Test-Path $adrReadme) -Detail $(if (Test-Path $adrReadme) { 'ok' } else { 'missing' })

$promptFiles = @(Get-ChildItem (Join-Path $root '.ai\prompts') -Filter '*.md' -ErrorAction SilentlyContinue)
Write-Check -Name 'prompt templates' -Ok ($promptFiles.Count -ge 11) -Detail ("{0} file(s)" -f $promptFiles.Count)

Write-Host ''
Write-Host ("Summary: {0} failure(s), {1} warning(s)" -f $failures, $warnings)
if ($failures -gt 0) { exit 1 }
exit 0
