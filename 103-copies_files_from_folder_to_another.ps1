$sourceFolder = "C:\Users\adub\Documents\RepoBen\HealthManagement"
$destinationFolder = "C:\Users\Personal\Powershell Scripts\PowershellTutorials\copied_files"

$files = Get-ChildItem -Path $sourceFolder -Recurse -File

foreach ($file in $files) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $destinationPath = Join-Path -Path $destinationFolder -ChildPath ("{0}_{1}{2}" -f ($file.BaseName, $timestamp, $file.Extension))
    if (-not (Test-Path -Path $destinationPath)) {
        try {
            Copy-Item -Path $file.FullName -Destination $destinationPath -ErrorAction Stop
            Write-Host -Object ("Copied {0} to {1}" -f $file.FullName, $destinationPath)
        }
        catch {
            Write-Error -Message ("Error copying {0} to {1}: {2}" -f $file.FullName, $destinationPath, $_.Exception.Message)
        }
    }
    else {
        Write-Warning -Message ("File {0} already exists at {1}" -f $file.Name, $destinationPath)
    }
}


