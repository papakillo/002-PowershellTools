$sourceUri = "ftp://username:password@source.example.com:21/sourcefolder/"
$destinationUri = "ftp://username:password@destination.example.com:21/destinationfolder/"
$filePattern = "*.txt" # Specify the file pattern to transfer

$webclient = New-Object System.Net.WebClient

try {
    $files = $webclient.ListFileContents($sourceUri) | Where-Object { $_ -like $filePattern }
    foreach ($file in $files) {
        $sourceFile = $sourceUri + $file
        $destinationFile = $destinationUri + $file
        Write-Progress -Activity "Copying files" -Status $file
        $webclient.UploadFile($destinationFile, $sourceFile)
    }
}
catch {
    Write-Error $_.Exception.Message
}
