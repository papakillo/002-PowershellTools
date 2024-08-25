# Set the directory path where your files are located
$sourceDir = "C:\checkben"
$destDir = "C:\checkben\renamed"

# Ensure the destination directory exists
if (-not (Test-Path -Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir
}

# Get all .csv_*.csv files in the specified directory
$files = Get-ChildItem -Path $sourceDir -Filter "*.csv_20240412*" -Recurse -File

# Initialize progress bar
$totalFiles = $files.Count
$currentFileIndex = 0

foreach ($file in $files) {
    $currentFileIndex++
    
    # Show progress
    Write-Progress -Activity "Renaming Files" -Status "Processing $currentFileIndex of $totalFiles" -PercentComplete (($currentFileIndex / $totalFiles) * 100)
    
    try {
        # Get the full filename and extension
        $filename = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $extension = [System.IO.Path]::GetExtension($file.Name)

        # Extract the part before ".csv_20240412"
        $newFilename = $filename -replace '\.csv_20240412.*', ''

        # Define new file path
        $newFilePath = Join-Path -Path $destDir -ChildPath "$newFilename.csv"
        
        # Rename and move the file
        Move-Item -Path $file.FullName -Destination $newFilePath -ErrorAction Stop
    }
    catch {
        Write-Error "Error processing file $($file.FullName): $_"
    }
}

Write-Host "Files renamed successfully."
