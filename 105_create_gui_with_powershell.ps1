Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "File Copy Utility"
$form.Width = 400
$form.Height = 300

$sourceLabel = New-Object System.Windows.Forms.Label
$sourceLabel.Text = "Source:"
$sourceLabel.Location = New-Object System.Drawing.Point(10, 10)
$sourceLabel.AutoSize = $true
$form.Controls.Add($sourceLabel)

$sourceTextBox = New-Object System.Windows.Forms.TextBox
$sourceTextBox.Location = New-Object System.Drawing.Point(10, 30)
$sourceTextBox.Width = 300
$form.Controls.Add($sourceTextBox)

$sourceButton = New-Object System.Windows.Forms.Button
$sourceButton.Text = "Browse"
$sourceButton.Location = New-Object System.Drawing.Point(320, 30)
$sourceButton.Width = 60
$form.Controls.Add($sourceButton)

$destinationLabel = New-Object System.Windows.Forms.Label
$destinationLabel.Text = "Destination:"
$destinationLabel.Location = New-Object System.Drawing.Point(10, 60)
$destinationLabel.AutoSize = $true
$form.Controls.Add($destinationLabel)

$destinationTextBox = New-Object System.Windows.Forms.TextBox
$destinationTextBox.Location = New-Object System.Drawing.Point(10, 80)
$destinationTextBox.Width = 300
$form.Controls.Add($destinationTextBox)

$destinationButton = New-Object System.Windows.Forms.Button
$destinationButton.Text = "Browse"
$destinationButton.Location = New-Object System.Drawing.Point(320, 80)
$destinationButton.Width = 60
$form.Controls.Add($destinationButton)

$copyButton = New-Object System.Windows.Forms.Button
$copyButton.Text = "Copy"
$copyButton.Location = New-Object System.Drawing.Point(10, 120)
$copyButton.Width = 100
$form.Controls.Add($copyButton)

$sourceButton.Add_Click({
    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowserDialog.Description = "Select Source Folder"
    if ($folderBrowserDialog.ShowDialog() -eq "OK") {
        $sourceTextBox.Text = $folderBrowserDialog.SelectedPath
    }
})

$destinationButton.Add_Click({
    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowserDialog.Description = "Select Destination Folder"
    if ($folderBrowserDialog.ShowDialog() -eq "OK") {
        $destinationTextBox.Text = $folderBrowserDialog.SelectedPath
    }
})

$copyButton.Add_Click({
    $source = $sourceTextBox.Text
    $destination = $destinationTextBox.Text
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination $destination -Recurse
    } else {
        [System.Windows.Forms.MessageBox]::Show("Invalid source path")
    }
})

$form.ShowDialog()
