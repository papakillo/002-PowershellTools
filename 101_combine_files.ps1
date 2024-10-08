#==============================================================
# Scriptname  : 101-combine_files.ps1
# Description : script that copies the latest files from a specified 
#               folder spanning the last 1 week, checks for folder existence,
#               groups the files into batches based on creation or 
#               modified date, zips the files, and logs the results to 
#               a text file:
# Author      : Benjamin Ohene-Adu
# Date        : 17th May 2024
#
#==============================================================

# Set the source and destination folder paths
$sourceFolder = "C:\Users\Admin\Downloads"
$destinationFolder = "C:\Users\Admin\Downloads\TestCopies"

# Set the log file path
$logFilePath = "C:\Path\To\Log\File.txt"

# Check if the source folder exists
if (-not (Test-Path $sourceFolder)) {
    Write-Host "Source folder does not exist: $sourceFolder"
    return
}

# Create the destination folder if it doesn't exist
if (-not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

# Create the log file path if it doesn't exist
$logFileDirectory = Split-Path $logFilePath -Parent
if (-not (Test-Path $logFileDirectory)) {
    New-Item -ItemType Directory -Path $logFileDirectory -Force | Out-Null
}

# Get the latest files from the last 1 week
$cutoffDate = (Get-Date).AddDays(-7)
$files = Get-ChildItem -Path $sourceFolder -File | Where-Object { $_.LastWriteTime -ge $cutoffDate }

# Group the files by creation or modified date
$fileGroups = $files | Group-Object -Property { $_.LastWriteTime.ToString("yyyy-MM-dd") }

# Process each file group
foreach ($group in $fileGroups) {
    $groupDate = $group.Name
    $groupFolder = Join-Path $destinationFolder $groupDate
    New-Item -ItemType Directory -Path $groupFolder -Force | Out-Null

    # Copy files to the group folder
    foreach ($file in $group.Group) {
        $sourcePath = $file.FullName
        $destinationPath = Join-Path $groupFolder $file.Name
        Copy-Item -Path $sourcePath -Destination $destinationPath
    }

    # Zip the files in the group folder
    $zipFilePath = Join-Path $groupFolder "$groupDate.zip"
    Compress-Archive -Path (Join-Path $groupFolder "*") -DestinationPath $zipFilePath -Force

    # Log the results
    $logEntry = "Zipped files for $groupDate to $zipFilePath"
    Add-Content -Path $logFilePath -Value $logEntry
}
