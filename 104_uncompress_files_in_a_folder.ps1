$sourceFolder = "C:\Source\ZippedFiles"
$destinationFolder = "C:\Destination"

$zipFiles = Get-ChildItem -Path $sourceFolder -Filter *.zip -Recurse

foreach ($zipFile in $zipFiles) {
    try {
        Expand-Archive -Path $zipFile.FullName -DestinationPath $destinationFolder -Force
        Write-Host "Successfully unzipped $($zipFile.Name) to $destinationFolder"
    }
    catch {
        Write-Warning "Error unzipping $($zipFile.Name): $($_.Exception.Message)"
    }
}

# pick the files from the destination folder and append a timestamp to the file name
$destinationFiles = Get-ChildItem -Path $destinationFolder -Recurse -File
# the timestamp format is yyyyMMddHHmmss
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
#append the timestamp to the file name
foreach ($file in $destinationFiles) {
    $newFileName = $file.Name + "_" + $timestamp + $file.Extension
    Rename-Item -Path $file.FullName -NewName $newFileName
    
    Write-Host "Renamed $($file.Name) to $newFileName"
    Write-Host "File path: $($file.FullName)"
    Write-Host "File name: $($file.Name)"
    Write-Host "File extension: $($file.Extension)"
    Write-Host "File size: $($file.Length)"
    Write-Host "File last modified: $($file.LastWriteTime)"
    Write-Host "File last accessed: $($file.LastAccessTime)"
    Write-Host "File created: $($file.CreationTime)"
    Write-Host "File attributes: $($file.Attributes)"
    Write-Host "File version: $($file.VersionInfo.FileVersion)"
}