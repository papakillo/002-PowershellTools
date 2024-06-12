<#
.SYNOPSIS
Copies files from a source folder to a destination folder and creates a zip archive of the destination folder.

.DESCRIPTION
This script performs the following actions:
1. Copies all files and folders from the source folder to the destination folder, recursively and overwriting any existing files.
2. Creates a zip archive of the destination folder and saves it to the specified zip file path.

.PARAMETER SourceFolder
The path to the source folder containing the files to be copied.

.PARAMETER DestinationFolder
The path to the destination folder where the files will be copied to.

.PARAMETER ZipFile
The path to the zip file that will be created, containing the contents of the destination folder.

.EXAMPLE
103_copies_files_and_zip_archive.ps1 -SourceFolder "C:\Source\Files" -DestinationFolder "C:\Destination\Files" -ZipFile "C:\Destination\Files.zip"
#>
$sourceFolder = "C:\Source\Files"
$destinationFolder = "C:\Destination\Files"
$zipFile = "C:\Destination\Files.zip"

# Copy files from source to destination
Copy-Item -Path $sourceFolder\* -Destination $destinationFolder -Recurse -Force

# Compress destination folder to zip file
Compress-Archive -Path $destinationFolder\* -DestinationPath $zipFile
$sourceFolder = "C:\Source\Files"
$destinationFolder = "C:\Destination\Files"
$zipFile = "C:\Destination\Files.zip"

# Copy files from source to destination
Copy-Item -Path $sourceFolder\* -Destination $destinationFolder -Recurse -Force

# Compress destination folder to zip file
Compress-Archive -Path $destinationFolder\* -DestinationPath $zipFile
