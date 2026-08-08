# Shared metadata reader for config/project.yaml (flat key: value format).
function Get-ProjectMetadata {
    param([string]$Root)

    $path = Join-Path $Root 'config\project.yaml'
    $meta = @{
        name = ''
        language_profile = ''
        version = ''
        toolchain = ''
        targets = ''
        hardware = ''
    }

    if (Test-Path $path) {
        Get-Content $path | ForEach-Object {
            $line = $_.Trim()
            if ($line -and -not $line.StartsWith('#')) {
                $parts = $line -split ':', 2
                if ($parts.Count -eq 2) {
                    $key = $parts[0].Trim()
                    $value = $parts[1].Trim().Trim('"').Trim("'")
                    if ($meta.ContainsKey($key)) {
                        $meta[$key] = $value
                    }
                }
            }
        }
    }

    return [pscustomobject]$meta
}
