<#
.SYNOPSIS
Read-only AI governance consistency validator.
.DESCRIPTION
Validates rule IDs, owners, references, layer boundaries, exceptions and the
governance index. Never modifies files.
#>
param(
    [string]$RepoRoot = '',
    [string[]]$Checks = @(),
    [ValidateSet('Text', 'Json')]
    [string]$OutputFormat = 'Text',
    [switch]$TreatWarningAsError
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$script:RepoRoot = if ($RepoRoot) { $RepoRoot } else { Split-Path -Parent $PSScriptRoot }
$script:RepoRoot = [System.IO.Path]::GetFullPath($script:RepoRoot)
if (-not (Test-Path -LiteralPath $script:RepoRoot -PathType Container)) {
    throw "RepoRoot not found: $script:RepoRoot"
}

function Get-RepoPath {
    param([string]$Path)
    if (-not $Path) { return '' }
    $p = $Path.Trim().Trim('`').Trim('"').Trim("'")
    if (-not $p) { return '' }
    if ($p -match '^(https?|mailto):') { return $p }
    if ([System.IO.Path]::IsPathRooted($p)) { return [System.IO.Path]::GetFullPath($p) }
    return [System.IO.Path]::GetFullPath((Join-Path $script:RepoRoot $p))
}

function Get-RepoRelative {
    param([string]$FullPath)
    if (-not $FullPath) { return '' }
    $root = $script:RepoRoot
    if ($FullPath.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return ($FullPath.Substring($root.Length) -replace '^[\\/]+', '')
    }
    return $FullPath
}

function Read-GovernanceChecksYaml {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Missing governance-checks.yaml: $Path"
    }
    $checks = [ordered]@{}
    foreach ($line in @(Get-Content -LiteralPath $Path -Encoding UTF8)) {
        $trim = $line.Trim()
        if (-not $trim -or $trim.StartsWith('#')) { continue }
        if ($line -match '^\s*checks\s*:') { continue }
        if ($line -match '^  (GOV-\d{3})\s*:') {
            $id = $Matches[1]
            $checks[$id] = @{ name = ''; owner = ''; description = '' }
            continue
        }
        if ($checks.Count -gt 0 -and $line -match '^    (name|owner|description)\s*:\s*(.*)$') {
            $key = $Matches[1]
            $value = $Matches[2].Trim().Trim('"').Trim("'")
            $current = @($checks.Keys)[-1]
            $checks[$current][$key] = $value
        }
    }
    if ($checks.Count -eq 0) {
        throw "No GOV checks defined in $Path"
    }
    return $checks
}

function Read-RuleRegistry {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Missing governance-index.md: $Path"
    }
    $registry = [ordered]@{}
    $lines = @(Get-Content -LiteralPath $Path -Encoding UTF8)
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match '^\|\s*(META|EXE|ADR|DOD|REV|G|EXC)-\d{3}\s*\|') {
            $cols = @($line -split '\|')
            if ($cols.Count -ge 5) {
                $id = $cols[1].Trim()
                $name = $cols[2].Trim()
                $owner = $cols[3].Trim().Trim('`')
                $validation = $cols[4].Trim()
                if ($registry.Contains($id)) {
                    $registry[$id].DuplicateRows += 1
                } else {
                    $registry[$id] = [pscustomobject]@{
                        Id = $id
                        Name = $name
                        Owner = $owner
                        OwnerPath = Get-RepoPath -Path $owner
                        Validation = $validation
                        Line = $i + 1
                        DuplicateRows = 0
                    }
                }
            }
        }
    }
    return $registry
}

function Get-MarkdownPlainLines {
    param([string]$Path)
    $result = @()
    if (-not (Test-Path -LiteralPath $Path)) { return $result }
    $lines = @(Get-Content -LiteralPath $Path -Encoding UTF8)
    $inFence = $false
    $fenceChar = ''
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $trim = $lines[$i].Trim()
        if ($trim -match '^(```|~~~)') {
            if (-not $inFence) {
                $inFence = $true
                $fenceChar = $trim.Substring(0, 3)
            } elseif ($trim.StartsWith($fenceChar)) {
                $inFence = $false
            }
            continue
        }
        if (-not $inFence) {
            $result += [pscustomobject]@{ Line = $i + 1; Text = $lines[$i] }
        }
    }
    return $result
}

function Get-MarkdownHeadings {
    param([string]$Path)
    $result = @()
    foreach ($l in Get-MarkdownPlainLines -Path $Path) {
        if ($l.Text -match '^(#{1,6})\s+(.*)$') {
            $result += [pscustomobject]@{ Line = $l.Line; Level = $Matches[1].Length; Text = $Matches[2].Trim() }
        }
    }
    return $result
}

function Get-RuleIdFromText {
    param([string]$Text)
    if ($Text -match '\b(META|EXE|ADR|DOD|REV|G|EXC)-\d{3}\b') {
        return $Matches[0]
    }
    return $null
}

function Test-FileRefCandidate {
    param([string]$Target)
    if (-not $Target) { return $false }
    if ($Target -match '\s') { return $false }
    if ($Target -match '^[/\\]') { return $true }
    if ($Target -in @('AGENTS.md', 'README.md', 'AI_REVIEW_RULES.md', 'AI_QUALITY_GATE.md')) { return $true }
    if ($Target -match '[/\\]') {
        $allowed = @('AGENTS.md', 'README.md', 'AI_', '.ai', 'docs', 'config', 'scripts', 'spec', 'src', 'tests', 'tools', 'third_party', 'build', '.github')
        foreach ($p in $allowed) {
            if ($Target.StartsWith($p, [System.StringComparison]::OrdinalIgnoreCase)) { return $true }
        }
    }
    return $false
}

function Get-RuleDefinitionsAll {
    $defs = @()
    $files = @(
        (Join-Path $script:RepoRoot 'AGENTS.md'),
        (Join-Path $script:RepoRoot '.ai\conventions.md'),
        (Join-Path $script:RepoRoot 'AI_REVIEW_RULES.md'),
        (Join-Path $script:RepoRoot 'AI_QUALITY_GATE.md')
    )
    foreach ($file in $files) {
        foreach ($h in Get-MarkdownHeadings -Path $file) {
            $id = Get-RuleIdFromText -Text $h.Text
            if ($id) {
                $defs += [pscustomobject]@{ Id = $id; File = $file; Line = $h.Line; Kind = 'heading' }
            }
        }
        foreach ($l in Get-MarkdownPlainLines -Path $file) {
            if ($l.Text -match '^\|\s*(EXC-\d{3})\s*\|') {
                $defs += [pscustomobject]@{ Id = $Matches[1]; File = $file; Line = $l.Line; Kind = 'table' }
            }
        }
    }
    $agents = Join-Path $script:RepoRoot 'AGENTS.md'
    $hasAdrDef = @($defs | Where-Object { $_.Id -eq 'ADR-001' }).Count -gt 0
    if (-not $hasAdrDef) {
        foreach ($l in Get-MarkdownPlainLines -Path $agents) {
            if ($l.Text -match '\bADR\b') {
                $defs += [pscustomobject]@{ Id = 'ADR-001'; File = $agents; Line = $l.Line; Kind = 'hard-constraint' }
                break
            }
        }
    }
    return $defs
}

function New-CheckResult {
    param([string]$Id, [string]$Name, [string]$Status, [string]$Detail, $Evidence)
    [pscustomobject]@{
        Id = $Id
        Name = $Name
        Status = $Status
        Detail = $Detail
        Evidence = @($Evidence)
    }
}

function Invoke-Gov001 {
    param($Registry)
    $name = 'Rule ID Integrity'
    $allDefs = Get-RuleDefinitionsAll
    $issues = @()
    $evidence = @()
    foreach ($id in $Registry.Keys) {
        if ($Registry[$id].DuplicateRows -gt 0) {
            $issues += "duplicate registry row: $id"
            $evidence += [pscustomobject]@{ type = 'duplicate'; rule_id = $id; file = '.ai/governance-index.md'; line = $Registry[$id].Line }
        }
    }
    $groups = @($allDefs | Group-Object Id)
    foreach ($g in $groups) {
        if ($g.Count -gt 1) {
            $issues += "duplicate definition: $($g.Name)"
            foreach ($d in $g.Group) {
                $evidence += [pscustomobject]@{ type = 'duplicate'; rule_id = $d.Id; file = (Get-RepoRelative $d.File); line = $d.Line }
            }
        }
    }
    $definedIds = @($allDefs | ForEach-Object { $_.Id } | Sort-Object -Unique)
    foreach ($id in $Registry.Keys) {
        if ($definedIds -notcontains $id) {
            $issues += "missing definition: $id"
            $evidence += [pscustomobject]@{ type = 'missing'; rule_id = $id; file = '.ai/governance-index.md'; line = $Registry[$id].Line }
        }
    }
    foreach ($id in $definedIds) {
        if (-not $Registry.Contains($id)) {
            $issues += "unregistered: $id"
            $d = $allDefs | Where-Object { $_.Id -eq $id } | Select-Object -First 1
            $evidence += [pscustomobject]@{ type = 'unregistered'; rule_id = $id; file = (Get-RepoRelative $d.File); line = $d.Line }
        }
    }
    $status = if ($issues.Count -eq 0) { 'PASS' } else { 'FAIL' }
    $detail = if ($status -eq 'PASS') { "$($Registry.Count) IDs registered; no duplicate, missing or unregistered ID" } else { ($issues -join '; ') }
    New-CheckResult -Id 'GOV-001' -Name $name -Status $status -Detail $detail -Evidence $evidence
}

function Invoke-Gov002 {
    param($Registry)
    $name = 'Owner Integrity'
    $allDefs = Get-RuleDefinitionsAll
    $issues = @()
    $evidence = @()
    foreach ($id in $Registry.Keys) {
        $row = $Registry[$id]
        $ownerRel = Get-RepoRelative $row.OwnerPath
        $bodyDefs = @($allDefs | Where-Object { $_.Id -eq $id -and (Get-RepoRelative $_.File) -eq $ownerRel })
        $conflicts = @($allDefs | Where-Object { $_.Id -eq $id -and (Get-RepoRelative $_.File) -ne $ownerRel })
        $ownerExists = Test-Path -LiteralPath $row.OwnerPath
        $bodyLine = 0
        if ($bodyDefs.Count -gt 0) { $bodyLine = $bodyDefs[0].Line }
        $itemOk = $ownerExists -and ($bodyDefs.Count -gt 0) -and ($conflicts.Count -eq 0) -and ($row.DuplicateRows -eq 0)
        if (-not $ownerExists) { $issues += "owner file missing: $id -> $($row.Owner)" }
        if ($bodyDefs.Count -eq 0) { $issues += "rule body missing: $id -> $($row.Owner)" }
        foreach ($c in $conflicts) { $issues += "owner conflict: $id in $(Get-RepoRelative $c.File)" }
        if ($row.DuplicateRows -gt 0) { $issues += "duplicate owner row: $id" }
        $itemStatus = if ($itemOk) { 'PASS' } else { 'FAIL' }
        $evidence += [pscustomobject]@{
            rule_id = $id
            owner = $ownerRel
            owner_exists = $ownerExists
            body_line = $bodyLine
            conflict_count = $conflicts.Count
            status = $itemStatus
        }
    }
    $status = if ($issues.Count -eq 0) { 'PASS' } else { 'FAIL' }
    $detail = if ($status -eq 'PASS') { 'Every rule has exactly one owner; owner files and rule bodies exist' } else { ($issues -join '; ') }
    New-CheckResult -Id 'GOV-002' -Name $name -Status $status -Detail $detail -Evidence $evidence
}

function Invoke-Gov003 {
    param($Registry)
    $name = 'Reference Integrity'
    $issues = @()
    $warnings = @()
    $evidence = @()
    $registeredIds = @($Registry.Keys)
    $scanFiles = @(
        'AGENTS.md', 'README.md', '.ai\conventions.md', 'AI_REVIEW_RULES.md', 'AI_QUALITY_GATE.md',
        '.ai\governance-index.md', '.ai\prompts\_checklist.md', '.ai\status.md', '.ai\handoff.md',
        '.ai\task-log.md', 'docs\decisions\README.md', 'spec\README.md', 'config\README.md',
        '.github\workflows\ci.yml'
    )
    $adrDir = Join-Path $script:RepoRoot 'docs\decisions'
    $adrReadme = Join-Path $adrDir 'README.md'

    foreach ($rel in $scanFiles) {
        $path = Join-Path $script:RepoRoot $rel
        if (-not (Test-Path -LiteralPath $path)) { continue }
        foreach ($l in Get-MarkdownPlainLines -Path $path) {
            $lineText = $l.Text
            if ($lineText -match '^\s*- P[23]') { continue }
            $backtickMatches = [regex]::Matches($lineText, '`([^`]+)`')
            foreach ($m in $backtickMatches) {
                $target = $m.Groups[1].Value.Trim()
                if (-not $target) { continue }
                if ($target -match '^(https?|mailto):' -or $target.StartsWith('#')) { continue }
                if ($target -match '[<>*?{}]') { continue }
                if ($target -match '^(META|EXE|ADR|DOD|REV|G|EXC)-\d{3}$') { continue }
                if ($target -match '^ADR-\d{4}$' -or $target -match '^GOV-\d{3}$') { continue }
                if (-not (Test-FileRefCandidate -Target $target)) { continue }
                $full = Get-RepoPath -Path $target
                if ($full -and -not (Test-Path -LiteralPath $full)) {
                    $issues += "dead file reference: $rel -> $target"
                    $evidence += [pscustomobject]@{ type = 'file'; source = $rel; line = $l.Line; target = $target; status = 'FAIL' }
                }
            }
            $linkMatches = [regex]::Matches($lineText, '\[[^\]]+\]\(([^)]+)\)')
            foreach ($m in $linkMatches) {
                $target = $m.Groups[1].Value.Trim()
                if (-not $target) { continue }
                if ($target -match '^(https?|mailto):' -or $target.StartsWith('#')) { continue }
                if ($target -match '[<>*?{}]') { continue }
                if ($target -match '^(META|EXE|ADR|DOD|REV|G|EXC)-\d{3}$') { continue }
                if ($target -match '^ADR-\d{4}$' -or $target -match '^GOV-\d{3}$') { continue }
                if (-not (Test-FileRefCandidate -Target $target)) { continue }
                $full = Get-RepoPath -Path $target
                if ($full -and -not (Test-Path -LiteralPath $full)) {
                    $issues += "dead link: $rel -> $target"
                    $evidence += [pscustomobject]@{ type = 'file'; source = $rel; line = $l.Line; target = $target; status = 'FAIL' }
                }
            }
            foreach ($rm in [regex]::Matches($lineText, '\b(META|EXE|ADR|DOD|REV|G|EXC)-\d{3}\b')) {
                $rid = $rm.Value
                if ($registeredIds -notcontains $rid) {
                    $issues += "unregistered rule reference: $rid in $rel"
                    $evidence += [pscustomobject]@{ type = 'rule'; source = $rel; line = $l.Line; target = $rid; status = 'FAIL' }
                }
            }
            $acceptWord = [string][char]0x9A8C + [char]0x6536
            $satisfyWord = [string][char]0x6EE1 + [char]0x8DB3
            $semanticHit = ($lineText -match 'G-001') -and (($lineText -match 'overall|satisfied|passed|acceptance') -or $lineText.Contains($acceptWord) -or $lineText.Contains($satisfyWord))
            if ($semanticHit) {
                $warnings += "semantic reference: G-001 used as overall gate in $rel"
                $evidence += [pscustomobject]@{ type = 'rule_semantic'; source = $rel; line = $l.Line; target = 'G-001'; status = 'WARNING' }
            }
            foreach ($am in [regex]::Matches($lineText, 'ADR-(\d{4})')) {
                $num = $am.Groups[1].Value
                $files = @(Get-ChildItem -LiteralPath $adrDir -Filter "$num-*.md" -ErrorAction SilentlyContinue)
                $indexed = $false
                if (Test-Path -LiteralPath $adrReadme) {
                    $indexed = @(Get-Content -LiteralPath $adrReadme -Encoding UTF8 | Where-Object { $_ -match "^\|\s*$num\s*\|" }).Count -gt 0
                }
                if ($files.Count -eq 0 -or -not $indexed) {
                    $issues += "dead ADR reference: ADR-$num in $rel"
                    $evidence += [pscustomobject]@{ type = 'adr'; source = $rel; line = $l.Line; target = "ADR-$num"; status = 'FAIL' }
                }
            }
        }
    }
    $status = if ($issues.Count -gt 0) { 'FAIL' } elseif ($warnings.Count -gt 0) { 'WARNING' } else { 'PASS' }
    $detail = if ($status -eq 'PASS') { 'No dead file, rule or ADR references' } elseif ($status -eq 'WARNING') { ($warnings -join '; ') } else { ($issues -join '; ') }
    New-CheckResult -Id 'GOV-003' -Name $name -Status $status -Detail $detail -Evidence $evidence
}

function Invoke-Gov004 {
    $name = 'Layer Boundary'
    $allowed = [ordered]@{
        'AGENTS.md' = @()
        '.ai\conventions.md' = @('META', 'DOD', 'EXE')
        'AI_REVIEW_RULES.md' = @('REV')
        'AI_QUALITY_GATE.md' = @('G', 'EXC')
    }
    $expectedByPrefix = @{
        'META' = '.ai/conventions.md'
        'DOD' = '.ai/conventions.md'
        'EXE' = '.ai/conventions.md'
        'REV' = 'AI_REVIEW_RULES.md'
        'G' = 'AI_QUALITY_GATE.md'
        'EXC' = 'AI_QUALITY_GATE.md'
        'ADR' = 'AGENTS.md'
    }
    $issues = @()
    $evidence = @()
    foreach ($rel in $allowed.Keys) {
        $path = Join-Path $script:RepoRoot $rel
        foreach ($h in Get-MarkdownHeadings -Path $path) {
            $id = Get-RuleIdFromText -Text $h.Text
            if (-not $id) { continue }
            $prefix = ($id -split '-')[0]
            $allowedPrefixes = @($allowed[$rel])
            if ($allowedPrefixes -notcontains $prefix) {
                $expected = $expectedByPrefix[$prefix]
                $issues += "layer violation: $id defined in $rel (expected owner $expected)"
                $evidence += [pscustomobject]@{ file = $rel; line = $h.Line; detected_rule = $id; expected_owner = $expected }
            }
        }
    }
    $status = if ($issues.Count -eq 0) { 'PASS' } else { 'FAIL' }
    $detail = if ($status -eq 'PASS') { 'No rule definition section in a wrong layer' } else { ($issues -join '; ') }
    New-CheckResult -Id 'GOV-004' -Name $name -Status $status -Detail $detail -Evidence $evidence
}

function Invoke-Gov005 {
    param($Registry)
    $name = 'Exception Integrity'
    $gate = Join-Path $script:RepoRoot 'AI_QUALITY_GATE.md'
    $exceptions = @()
    $inTable = $false
    foreach ($l in Get-MarkdownPlainLines -Path $gate) {
        if ($l.Text -match '^#{1,6}\s+.*Template Exceptions') {
            $inTable = $true
            continue
        }
        if ($inTable -and $l.Text -match '^\| EXC-\d{3} \|') {
            $cols = @($l.Text -split '\|')
            if ($cols.Count -ge 7) {
                $exceptions += [pscustomobject]@{
                    Id = $cols[1].Trim()
                    Content = $cols[2].Trim()
                    Reason = $cols[3].Trim()
                    Impact = $cols[4].Trim()
                    Owner = $cols[5].Trim().Trim('`')
                    RemoveCondition = $cols[6].Trim()
                    Line = $l.Line
                }
            }
        }
    }
    $issues = @()
    $evidence = @()
    foreach ($e in $exceptions) {
        $registered = $Registry.Contains($e.Id)
        $ownerOk = ($e.Owner -eq 'AI_QUALITY_GATE.md')
        $fieldsOk = ($e.Reason -and $e.Impact -and $e.RemoveCondition)
        $itemStatus = if ($registered -and $ownerOk -and $fieldsOk) { 'PASS' } else { 'FAIL' }
        if (-not $registered) { $issues += "unregistered exception: $($e.Id)" }
        if (-not $ownerOk) { $issues += "invalid exception owner: $($e.Id)" }
        if (-not $fieldsOk) { $issues += "incomplete exception fields: $($e.Id)" }
        $evidence += [pscustomobject]@{
            exc_id = $e.Id
            registered = $registered
            owner = $e.Owner
            has_reason = [bool]$e.Reason
            has_impact = [bool]$e.Impact
            has_remove_condition = [bool]$e.RemoveCondition
            status = $itemStatus
        }
    }
    foreach ($id in $Registry.Keys) {
        if ($id -like 'EXC-*' -and @($exceptions | Where-Object { $_.Id -eq $id }).Count -eq 0) {
            $issues += "registry exception without table entry: $id"
            $evidence += [pscustomobject]@{ exc_id = $id; registered = $true; owner = ''; has_reason = $false; has_impact = $false; has_remove_condition = $false; status = 'FAIL' }
        }
    }
    $status = if ($issues.Count -eq 0) { 'PASS' } else { 'FAIL' }
    $detail = if ($status -eq 'PASS') { 'All EXC entries are registered with valid owner and remove condition' } else { ($issues -join '; ') }
    New-CheckResult -Id 'GOV-005' -Name $name -Status $status -Detail $detail -Evidence $evidence
}

function Invoke-Gov006 {
    param($Registry)
    $name = 'Governance Index Integrity'
    $allDefs = Get-RuleDefinitionsAll
    $issues = @()
    $evidence = @()
    foreach ($id in $Registry.Keys) {
        $row = $Registry[$id]
        $ownerRel = Get-RepoRelative $row.OwnerPath
        $bodyDefs = @($allDefs | Where-Object { $_.Id -eq $id -and (Get-RepoRelative $_.File) -eq $ownerRel })
        $actualFiles = @($allDefs | Where-Object { $_.Id -eq $id } | ForEach-Object { Get-RepoRelative $_.File } | Sort-Object -Unique)
        $bodyOk = ($bodyDefs.Count -gt 0)
        $ownerOk = ($actualFiles.Count -eq 1 -and $actualFiles[0] -eq $ownerRel)
        $itemStatus = if ($bodyOk -and $ownerOk) { 'PASS' } else { 'FAIL' }
        if (-not $bodyOk) { $issues += "registered rule without body: $id" }
        if (-not $ownerOk) { $issues += "owner mismatch: $id" }
        $evidence += [pscustomobject]@{
            rule_id = $id
            registry_owner = $ownerRel
            actual_owner = ($actualFiles -join ',')
            body_exists = $bodyOk
            status = $itemStatus
        }
    }
    foreach ($d in $allDefs) {
        if (-not $Registry.Contains($d.Id)) {
            $issues += "definition without registry entry: $($d.Id)"
            $evidence += [pscustomobject]@{ rule_id = $d.Id; registry_owner = ''; actual_owner = (Get-RepoRelative $d.File); body_exists = $true; status = 'FAIL' }
        }
    }
    $status = if ($issues.Count -eq 0) { 'PASS' } else { 'FAIL' }
    $detail = if ($status -eq 'PASS') { 'Governance index and rule files are consistent' } else { ($issues -join '; ') }
    New-CheckResult -Id 'GOV-006' -Name $name -Status $status -Detail $detail -Evidence $evidence
}

try {
    $checksYaml = Read-GovernanceChecksYaml -Path (Join-Path $script:RepoRoot '.ai\governance-checks.yaml')
    $registry = Read-RuleRegistry -Path (Join-Path $script:RepoRoot '.ai\governance-index.md')

    $selected = @()
    foreach ($c in $Checks) {
        $selected += @($c -split ',')
    }
    $selected = @($selected | ForEach-Object { $_.Trim() } | Where-Object { $_ })
    foreach ($s in $selected) {
        if (-not $checksYaml.Contains($s)) {
            throw "Unknown check: $s"
        }
    }

    $results = @()
    foreach ($id in $checksYaml.Keys) {
        if ($selected.Count -gt 0 -and $selected -notcontains $id) { continue }
        switch ($id) {
            'GOV-001' { $results += Invoke-Gov001 -Registry $registry }
            'GOV-002' { $results += Invoke-Gov002 -Registry $registry }
            'GOV-003' { $results += Invoke-Gov003 -Registry $registry }
            'GOV-004' { $results += Invoke-Gov004 }
            'GOV-005' { $results += Invoke-Gov005 -Registry $registry }
            'GOV-006' { $results += Invoke-Gov006 -Registry $registry }
        }
    }

    $passCount = @($results | Where-Object { $_.Status -eq 'PASS' }).Count
    $warningCount = @($results | Where-Object { $_.Status -eq 'WARNING' }).Count
    $failCount = @($results | Where-Object { $_.Status -eq 'FAIL' }).Count

    if ($OutputFormat -eq 'Json') {
        $summary = [pscustomobject]@{ pass = $passCount; warning = $warningCount; fail = $failCount; total = $results.Count }
        [pscustomobject]@{ schema = 'governance-check/v1'; checks = $results; summary = $summary } | ConvertTo-Json -Depth 6
    } else {
        foreach ($r in $results) {
            $tag = switch ($r.Status) { 'PASS' { 'PASS' } 'WARNING' { 'WARNING' } default { 'FAIL' } }
            Write-Host ("[{0}] {1} {2}" -f $tag, $r.Id, $r.Name)
            Write-Host ("Detail: {0}" -f $r.Detail)
            if ($r.Evidence.Count -gt 0) {
                Write-Host ("Evidence: {0}" -f ($r.Evidence | ConvertTo-Json -Compress -Depth 5))
            } else {
                Write-Host 'Evidence: none'
            }
        }
        Write-Host ''
        Write-Host ("Summary: {0} pass, {1} warning, {2} failure" -f $passCount, $warningCount, $failCount)
    }

    $exitFail = $failCount
    if ($TreatWarningAsError) { $exitFail += $warningCount }
    if ($exitFail -gt 0) { exit 1 } else { exit 0 }
} catch {
    Write-Host "[ERROR] $($_.Exception.Message)"
    exit 2
}
