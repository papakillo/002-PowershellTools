# Import the required assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml

# Define the XAML for the GUI layout
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="PowerShell GUI" Height="200" Width="400">
    <Grid>
        <Button Name="MyButton" Width="100" Height="30" VerticalAlignment="Center" HorizontalAlignment="Center">Click Me</Button>
    </Grid>
</Window>
"@

# Load the XAML into a PowerShell object
$XamlReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$XAML)
$Window = [System.Windows.Markup.XamlReader]::Load($XamlReader)

# Find the button in the XAML
$Button = $Window.FindName("MyButton")

# Define the button click event handler
$Button.Add_Click({
    [System.Windows.MessageBox]::Show("Hello, World!")
})

# Show the WPF window
$Window.ShowDialog() | Out-Null
