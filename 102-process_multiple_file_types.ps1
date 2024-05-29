<#

    Author: Benjamin Ohene-Adu
    Date: 2024-05-23
    Version: 1.0

 SYNOPSIS     : This script processes multiple file types (CSV, Excel, XML, DAT, etc.) from a specified folder and exports the data to CSV files.

 How it works : The script reads various file types from the specified folder, dynamically determines the data headers, and exports the content 
                to CSV files with appropriate timestamps. It also provides progress updates during the process.

 Parameter folderPath: The path to the folder containing the files to be processed.

 Parameter outputDirectory :   The directory where the output CSV files will be saved.

 
.EXAMPLE
    .\ProcessFilesToCsv.ps1

    This example runs the script to process files in the specified folder and save the output CSV files to the defined output directory.

#>

# Function to ensure ImportExcel module is available
function Ensure-ImportExcelModule {
    try {
        Import-Module -Name ImportExcel -ErrorAction Stop
    } catch {
        Write-Host "ImportExcel module not found. Installing ImportExcel module..."
        Install-Module -Name ImportExcel -Scope CurrentUser -Force
        Import-Module -Name ImportExcel -ErrorAction Stop
    }
}

# Ensure ImportExcel module is installed and imported
Ensure-ImportExcelModule

# Define the path to the folder containing the files
$folderPath = "C:\Users\adub\Downloads\Output"

# Define the output directory for CSV files
$outputDirectory = "C:\Users\adub\Downloads\Output\ben_imports"

write-host $folderPath

# Ensure the output directory exists
if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory
}

# Get all files in the folder
$files = Get-ChildItem -Path $folderPath -File

# Initialize progress bar
$totalFiles = $files.Count
$currentFileIndex = 0

write-host $totalFiles "Files"

foreach ($file in $files) {
    $currentFileIndex++
    $fileName = $file.Name
    $fileExtension = $file.Extension.ToLower()
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    
    Write-Progress -Activity "Processing Files" -Status "Processing $fileName ($currentFileIndex of $totalFiles)" -PercentComplete (($currentFileIndex / $totalFiles) * 100)

    switch ($fileExtension) {
        ".csv" {
            $data = Import-Csv -Path $file.FullName
        }
        ".xlsx" {
            $data = Import-Excel -Path $file.FullName
        }
        ".xml" {
            [xml]$xmlData = Get-Content -Path $file.FullName
            $data = $xmlData.SelectNodes("//Customer") | ForEach-Object {
                [PSCustomObject]@{
                    ID    = $_.ID
                    Name  = $_.Name
                    Email = $_.Email
                }
            }
        }
        ".dat" {
            $data = Get-Content -Path $file.FullName | ConvertFrom-Csv
        }
        default {
            Write-Host "Unsupported file type: $fileExtension"
            continue
        }
    }

      # Determine the data domain from the file name (example logic)
    if ($fileName -match "sales") {
        $dataDomain = "sales"
    } elseif ($fileName -match "customers") {
        $dataDomain = "customers"
    } elseif ($fileName -match "inventory") {
        $dataDomain = "inventory"
    } elseif ($fileName -match "purchase_orders") {
        $dataDomain = "purchase_orders"
    } else {
        $dataDomain = "unknown"
    }

    # Define the output CSV file name
    $outputFileName = "${dataDomain}_data_$timestamp.csv"
    $outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName

    # Export the data to a CSV file
    $data | Export-Csv -Path $outputFilePath -NoTypeInformation

    Write-Host "Processed $fileName and exported to $outputFilePath"
}

# Final progress bar completion
Write-Progress -Activity "Processing Files" -Status "Completed" -PercentComplete 100
Write-Host "All files processed successfully."