<#
    This is a feature build for password_validator.sh.
    The original script only checks for passwords comes from AD-HOC command.
    This feature is a solution for working with files and a decent summerization.
                
    The script breakes down to 6 main functions that checks if the string matches the requirements.
    1. Above 10 characters.
    2. Includes Digits [0-9]
    3. Includes Alpha [Aa-Zz]
    4. Includes Special [!@#$%^&*()_+=-]
    5. Includes Uppercase Letters [A-Z]
    6. Includes Lowercase Letters [a-z]
             
    Written by Gil Shwartz @2022

#>

function Show-Help {
    # Print Help Information
	Write-Host "A Script to test if a string passes the requirements."
	Write-Host "[A-Z] + [a-z] + [0-9] + [!@#$%^&*()+_:/.,] > 10 total characters."
	Write-Host ""
	Write-Host "-t 	password's text"
	Write-Host "-f	password's file"
	Write-Host ""
	Write-Host "Usage: .\password-validator.ps1 [-t] [text] | [-f] [path/to/filename]"
    Write-Host "Example: .\password-validator.ps1 -f .\passwords.txt"

}

function Check-Length {
    Param($string)

    if ($string.length -gt 10) {
        Write-Host "Length: PASS" -ForegroundColor Green
    }

     else {
        Write-Host "Length: FAIL" -ForegroundColor Red
    }
    
}

function Check-Digits {
    Param($string)
    if ("$string" -match '\d' -eq "True") {
        Write-Host "Digits: PASS" -ForegroundColor Green
        }

    else {
        Write-Host "Digits: FAIL" -ForegroundColor Red

    }

}

function Check-Special {
    Param($string)

    $pattern = "[^" + [regex]::Escape("~!@#$%^&()-.+=}{\/|;:<>?'*") + "]"
    $specials = $string -replace $pattern

    if ($specials.length -eq 0) {
        Write-Host "Specials: FAIL" -ForegroundColor Red
        }

    else {
        Write-Host "Specials: PASS" -ForegroundColor Green
        }
}

function Check-Alpha-Lower {
    Param($string)

    if ($string -cmatch "[a-z]") {
        Write-Host "Alpha: PASS" -ForegroundColor Green
    }

    else {
        Write-Host "Alpha: FAIL" -ForegroundColor Red
    }
}

function Check-Upper {
    Param($string)

    if ($string -cmatch "[A-Z]") {
        Write-Host "Upper: PASS" -ForegroundColor Green
        }

    else {
        Write-Host "Upper: FAIL" -ForegroundColor Red
    }
}

function Inspect-Text {
    Param($string)

    Write-Output "Checking password: $string"
    Check-Length -string $string
    Check-Digits -string $string
    Check-Special -string $string
    Check-Alpha-Lower -string $string
    Check-Upper -string $string

}

function Inspect-File {
    Param($file)

    foreach($line in Get-Content $file) {
        $ErrorActionPreference = 'silentlycontinue'

        Write-Host "========================"
        Write-Host "Checking Password: $line"

        Check-Length -string $line
        Check-Digits -string $line
        Check-Special -string $line
        Check-Alpha-Lower -string $line
        Check-Upper -string $line

        Write-Host $length $digits $special $alpha_lower $upper

        $checked++
    }
    
    Write-Host "Total checked: $checked"
    
}

# Initiate Lists, Counters & Dict
$passed = 0
$failed = 0
$checked = 0

$pass = @()
$fail = @()

# Respond to AD-HOC Command
if (($args.Count -gt 0) -and ($args[0] -eq "-t") -and ($args[1].length -gt 0)) {
    Inspect-Text -string $args[1]
}

elseif (($args.Count -gt 0) -and ($args[0] -eq "-f") -and ($args[1].length -gt 0)) {
    $is_file = Test-Path $args[1] -PathType Leaf
    if ($is_file) {
        Inspect-File -file $args[1]

        }

    else {
        Write-Host "No file selected." -ForegroundColor Red
    }
}

elseif (($args.Count -gt 0) -and ($args[0] -eq "-h") -and ($args[1].length -eq 0)) {
    Show-Help
}
