# Open notepad and show Hello World

# Suppress Irrelevant errors
$ErrorActionPreference = 'silentlycontinue'

# Create hello.txt file with Hello World inside
$file = $args[0]

# Check if file exists
$is_file = Test-Path $file -PathType Leaf
if (-not$is_file) {
    # Create file
    $file = New-Item $file

    # Write to file
    Set-Content $file "Hello World"

}

# Open file with notepad
start notepad "$file"