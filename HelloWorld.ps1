#get the list of files
# Set the folder path
$folderPath = "C:\Users\Admin\Downloads"

# Get all files in the folder
$files = Get-ChildItem -Path $folderPath -File

# Loop through each file and print its name
foreach ($file in $files) {
    Write-Host $file.Name
}

