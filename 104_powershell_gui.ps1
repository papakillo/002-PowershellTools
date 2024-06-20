# Create a new Windows Forms form
$form = New-Object System.Windows.Forms.Form
$form.Text = "File Copy Tool"
$form.Width = 400
$form.Height = 300

# Create a label for the source folder
$sourceLabel = New-Object System.Windows.Forms.Label
$sourceLabel.Text = "Source Folder:"
$sourceLabel.Location = New-Object System.Drawing.Point(10, 10)
$sourceLabel.AutoSize = $true
$form.Controls.Add($sourceLabel)

# Create a textbox for the source folder
$sourceTextBox = New-Object System.Windows.Forms.TextBox
$sourceTextBox.Location = New-Object System.Drawing.Point(100, 10)
$sourceTextBox.Width = 250
$form.Controls.Add($sourceTextBox)

# Create a button to browse for the source folder
$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "Browse"
$browseButton.Location = New-Object System.Drawing.Point(360, 10)
$browseButton.Width = 80
$form.Controls.Add($browseButton)

# Create a label for the destination folder
$destLabel = New-Object System.Windows.Forms.Label
$destLabel.Text = "Destination Folder:"
$destLabel.Location = New-Object System.Drawing.Point(10, 40)
$destLabel.AutoSize = $true
$form.Controls.Add($destLabel)

# Create a textbox for the destination folder
$destTextBox = New-Object System.Windows.Forms.TextBox
$destTextBox.Location = New-Object System.Drawing.Point(100, 40)
$destTextBox.Width = 250
$form.Controls.Add($destTextBox)

# Create a button to browse for the destination folder
$browseButton2 = New-Object System.Windows.Forms.Button
$browseButton2.Text = "Browse"
$browseButton2.Location = New-Object System.Drawing.Point(360, 40)
$browseButton2.Width = 80
$form.Controls.Add($browseButton2)

# Create a button to copy the files
$copyButton = New-Object System.Windows.Forms.Button
$copyButton.Text = "Copy Files"
$copyButton.Location = New-Object System.Drawing.Point(150, 80)
$copyButton.Width = 100
$form.Controls.Add($copyButton)

# Create a listbox to display errors
$errorListBox = New-Object System.Windows.Forms.ListBox
$errorListBox.Location = New-Object System.Drawing.Point(10, 120)
$errorListBox.Width = 370
$errorListBox.Height = 150
$form.Controls.Add($errorListBox)

# Event handler for the browse button
$browseButton.Add_Click({
        $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $result = $folderBrowserDialog.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $sourceTextBox.Text = $folderBrowserDialog.SelectedPath
            if ($null -eq $browseButton) {
                $browseButton = New-Object System.Windows.Forms.Button
            }

            if ($null -eq $browseButton2) {
                $browseButton2 = New-Object System.Windows.Forms.Button
            }
        }
    })

# Event handler for the browse button 2
$browseButton2.Add_Click({
        $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $result = $folderBrowserDialog.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $destTextBox.Text = $folderBrowserDialog.SelectedPath
        }
    })

# Event handler for the copy button
$copyButton.Add_Click({
        $sourceFolder = $sourceTextBox.Text
        $destFolder = $destTextBox.Text
        $files = Get-ChildItem -Path $sourceFolder -File
        $errorListBox.Items.Clear()

        foreach ($file in $files) {
            try {
                $destPath = Join-Path -Path $destFolder -ChildPath $file.Name
                Copy-Item -Path $file.FullName -Destination $destPath -Force
            }
            catch {
                $errorListBox.Items.Add("Error copying $($file.FullName): $($_.Exception.Message)")
            }
        }
    })

# Show the form
$form.ShowDialog()

