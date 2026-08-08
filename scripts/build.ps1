# Unified build/test entry. Profile is read from config/project.yaml unless overridden.
param(
    [ValidateSet('Build', 'Test', 'All')]
    [string]$Target = 'Build',
    [string]$Profile = ''
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'read-project.ps1')

$project = Get-ProjectMetadata -Root $root
if (-not $Profile) {
    $Profile = $project.language_profile
}

function Write-Report {
    param(
        [string]$Name,
        [string]$Profile,
        [string]$Status,
        [string]$Message = ''
    )

    $report = [pscustomobject]@{
        profile   = $Profile
        target    = $Name
        status    = $Status
        timestamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        message   = $Message
    }

    $reportFile = Join-Path $root ("build\last-{0}.json" -f $Name.ToLower())
    $report | ConvertTo-Json | Set-Content -Path $reportFile -Encoding ASCII
    Write-Host ("[{0}] {1}: {2}" -f $Status.ToUpper(), $Name, $Message)
}

function Invoke-BuildStep {
    param([string]$Name, [string]$Profile)

    switch ($Profile) {
        'c-cpp-embedded' {
            # TODO: replace with e.g. cmake --preset host-debug
            Write-Report -Name $Name -Profile $Profile -Status 'not_configured' -Message 'TODO: cmake --build ...'
        }
        'csharp-tool' {
            # TODO: replace with e.g. dotnet build src/MyTool.sln
            Write-Report -Name $Name -Profile $Profile -Status 'not_configured' -Message 'TODO: dotnet build ...'
        }
        'labview-ate' {
            # TODO: replace with VI Scripting build of the .lvproj build spec
            Write-Report -Name $Name -Profile $Profile -Status 'not_configured' -Message 'TODO: LabVIEW build via VI Scripting ...'
        }
        'python-automation' {
            # TODO: replace with e.g. uv build
            Write-Report -Name $Name -Profile $Profile -Status 'not_configured' -Message 'TODO: package build ...'
        }
        default {
            Write-Report -Name $Name -Profile $Profile -Status 'skipped' -Message 'No profile configured; set language_profile in config/project.yaml'
        }
    }
}

function Invoke-TestStep {
    param([string]$Name, [string]$Profile)

    switch ($Profile) {
        'c-cpp-embedded' {
            # TODO: replace with e.g. ctest --preset unit
            Write-Report -Name $Name -Profile $Profile -Status 'not_configured' -Message 'TODO: ctest ...'
        }
        'csharp-tool' {
            # TODO: replace with e.g. dotnet test
            Write-Report -Name $Name -Profile $Profile -Status 'not_configured' -Message 'TODO: dotnet test ...'
        }
        'labview-ate' {
            # TODO: replace with ATE self-test VI execution
            Write-Report -Name $Name -Profile $Profile -Status 'not_configured' -Message 'TODO: run ATE self-test VIs ...'
        }
        'python-automation' {
            # TODO: replace with e.g. uv run pytest
            Write-Report -Name $Name -Profile $Profile -Status 'not_configured' -Message 'TODO: pytest ...'
        }
        default {
            Write-Report -Name $Name -Profile $Profile -Status 'skipped' -Message 'No profile configured; set language_profile in config/project.yaml'
        }
    }
}

switch ($Target) {
    'Build' { Invoke-BuildStep -Name 'Build' -Profile $Profile }
    'Test'  { Invoke-TestStep  -Name 'Test'  -Profile $Profile }
    'All'   {
        Invoke-BuildStep -Name 'Build' -Profile $Profile
        Invoke-TestStep  -Name 'Test'  -Profile $Profile
    }
}
