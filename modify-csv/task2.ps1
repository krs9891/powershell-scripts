function Format-Name {
    param([string]$name)

    $first_name, $last_name = $name.ToLower().Split(' ', 2)

    $first_name = $first_name.Substring(0,1).ToUpper() + $first_name.Substring(1)
    $last_name = $last_name.Substring(0,1).ToUpper() + $last_name.Substring(1)

    if ($last_name -match "-") {
        $hyphen_pos = $last_name.IndexOf("-")
        $last_name = $last_name.Substring(0, $hyphen_pos) + "-" + $last_name.Substring($hyphen_pos+1, 1).ToUpper() + $last_name.Substring($hyphen_pos+2)
    }

    return "$first_name $last_name"
}

function Generate-Email {
    param([string]$alias, [string]$location_id)

    $domain = "@abc.com"
    $email = $alias

    if (Check-Alias $alias $alias_array) {
        $email += $location_id
    }

    return "$email$domain"
}

function Check-Alias {
    param([string]$alias, [string[]]$alias_array)

    $count = 0

    foreach ($element in $alias_array) {
        if ($element -eq $alias) {
            $count++
        }
    }

    if ($count -gt 1) {
        return $true
    } else {
        return $false
    }
}

function Create-Email-Alias {
    param([string]$name)

    $first_name, $last_name = $name -split ' ', 2

    $alias = ($first_name.Substring(0,1) + $last_name).ToLower()
    return $alias
}

if ($args.Count -ne 1) {
    Write-Host "Usage: $($MyInvocation.MyCommand) <csv_directory\accounts.csv>"
    exit 1
}

$alias_array = @()

$csv_directory = Split-Path $args[0]
$input_file = Join-Path $csv_directory "accounts.csv"
$output_file = Join-Path $csv_directory "accounts_new.csv"

$header = Get-Content $input_file -TotalCount 1
$header | Out-File $output_file -Encoding UTF8

$skip_header = $true

Get-Content $input_file | ConvertFrom-Csv -Header "id", "location_id", "name", "title", "email", "department" | ForEach-Object {
    if ($skip_header) {
        $skip_header = $false
        return
    }

    $alias_array += (Create-Email-Alias $_.name)
}

$skip_header = $true

Get-Content $input_file | ConvertFrom-Csv -Header "id", "location_id", "name", "title", "email", "department" | ForEach-Object {
    if ($skip_header) {
        $skip_header = $false
        return
    }

    $line = $_
    
    $id = $line.id
    $location_id = $line.location_id
    $name = $line.name
    $title = $line.title
    $email = $line.email
    $department = $line.department
    $formated_name = Format-Name $name
    $formated_email = Generate-Email (Create-Email-Alias $name) $location_id
    
    if ($title -match ",") {
        $title = """$title"""
    }

    "$id,$location_id,$formated_name,$title,$formated_email,$department" | Out-File $output_file -Append -Encoding UTF8
}

$skip_header = $true

Write-Host "processing done. $output_file created."
