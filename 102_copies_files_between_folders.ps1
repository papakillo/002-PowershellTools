<#
.SYNOPSIS
Copies files from one folder to another, creating the destination folder if it doesn't exist.

.DESCRIPTION
This script prompts the user to enter the source and destination folder paths, and then copies all files from the source folder to the destination folder. If the destination folder doesn't exist, it creates a new folder.

.PARAMETER SourceFolder
The path to the source folder containing the files to be copied.

.PARAMETER DestinationFolder
The path to the destination folder where the files will be copied to.

.EXAMPLE
.\102_copies_files_between_folders.ps1
Enter the source folder path: C:\source
Enter the destination folder path: C:\destination
Files copied successfully from C:\source to C:\destination
#>
#write a script to copy files from one folder to another with adequate checks
$sourceFolder = Read-Host "Enter the source folder path"
$destinationFolder = Read-Host "Enter the destination folder path"

if (!(Test-Path $sourceFolder)) {
    Write-Host "Source folder does not exist. Please provide a valid path."
    return
}

if (!(Test-Path $destinationFolder)) {
    Write-Host "Destination folder does not exist. Creating new folder..."
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

$files = Get-ChildItem -Path $sourceFolder -File

foreach ($file in $files) {
    $sourcePath = Join-Path $sourceFolder $file.Name
    $destinationPath = Join-Path $destinationFolder $file.Name
    
    Copy-Item -Path $sourcePath -Destination $destinationPath
}

Write-Host "Files copied successfully from $sourceFolder to $destinationFolder"


