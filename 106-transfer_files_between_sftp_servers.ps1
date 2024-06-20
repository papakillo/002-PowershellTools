
# Import the required module for SFTP operations
Import-Module SSH-Sessions

# Define the source and destination SFTP server details
$sourceServer = @{
    Hostname = "source_server_hostname"
    Port     = 22
    Username = "source_server_username"
    Password = "source_server_password"
}

$destinationServer = @{
    Hostname = "destination_server_hostname"
    Port     = 22
    Username = "destination_server_username"
    Password = "destination_server_password"
}

# Define the file pattern to be copied
$filePattern = "*.txt"

# Define the source and destination paths
$sourcePath = "/path/to/source/files"
$destinationPath = "/path/to/destination/files"

# Connect to the source SFTP server
$sourceSession = New-SFTPSession -Server $sourceServer

# Connect to the destination SFTP server
$destinationSession = New-SFTPSession -Server $destinationServer

# Get the list of files matching the file pattern from the source server
$filesToCopy = Get-SFTPChildItem -Session $sourceSession -Path $sourcePath -File | Where-Object { $_.Name -like $filePattern }

# Loop through each file and copy it to the destination server
foreach ($file in $filesToCopy) {
    $sourceFilePath = Join-Path -Path $sourcePath -ChildPath $file.Name
    $destinationFilePath = Join-Path -Path $destinationPath -ChildPath $file.Name

    try {
        # Copy the file from source to destination
        Copy-SFTPFile -Session $sourceSession -SourcePath $sourceFilePath -DestinationPath $destinationFilePath

        # Log the successful file transfer
        Write-Host "File $($file.Name) transferred successfully."
    }
    catch {
        # Log the error if file transfer fails
        Write-Host "Error transferring file $($file.Name): $($_.Exception.Message)"
    }
}

# Disconnect from the source and destination SFTP servers
Disconnect-SFTPSession -Session $sourceSession
Disconnect-SFTPSession -Session $destinationSession
