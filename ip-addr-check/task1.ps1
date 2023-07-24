param(
    [string]$ip_address_1,
    [string]$ip_address_2,
    [string]$network_mask
)

# Function to validate an IP address
function Validate-IPAddress {
    param(
        [string]$IPAddress
    )

    $parts = $IPAddress -split '\.'
    
    if ($parts.Count -ne 4) {
        Throw "Invalid IP address format. Please provide valid IP addresses."
    }
    
    foreach ($part in $parts) {
        if (-not $part -match '^\d+$' -or $part -lt 0 -or $part -gt 255) {
            Throw "Invalid IP address format. Please provide valid IP addresses."
        }
    }
}

# Function to validate the network mask
function Validate-NetworkMask {
    param(
        [string]$NetworkMask
    )
    
    $parts = $NetworkMask -split '\.'
    
    if ($parts.Count -eq 1) {
        if (-not $NetworkMask -match '^\d+$' -or [int]$NetworkMask -lt 0 -or [int]$NetworkMask -gt 32) {
            Throw "Invalid network mask format. Please provide a valid network mask."
        }
    } else {
        if ($parts.Count -ne 4) {
            Throw "Invalid network mask format. Please provide a valid network mask."
        }
        foreach ($part in $parts) {
            if (-not $part -match '^\d+$' -or $part -lt 0 -or $part -gt 255) {
                Throw "Invalid network mask format. Please provide a valid network mask."
            }
        }
    }
}

# Convert network mask to the full dotted format if it's in the shortened format
if ($network_mask.Length -eq 1) {
    $cidr = [int]$network_mask
    $full_dotted_mask = ("1" * $cidr).PadRight(32, "0")
    $mask_parts = for ($i = 0; $i -lt 4; $i++) { [convert]::ToInt32($full_dotted_mask.Substring($i * 8, 8), 2) }
    $network_mask = $mask_parts -join "."
}

# Validate IP addresses
try {
    Validate-IPAddress $ip_address_1
    Validate-IPAddress $ip_address_2
}
catch {
    Write-Host $_.Exception.Message
    exit 1
}

# Validate network mask
try {
    Validate-NetworkMask $network_mask
}
catch {
    Write-Host $_.Exception.Message
    exit 1
}

# Convert network mask to the full dotted format if it's in the shortened format
if ($network_mask.Length -eq 2) {
    $network_mask = "255." + ([Math]::Pow(2, (32 - [int]$network_mask)) - 1) + ".0.0"
}

# Convert IP addresses to integers for easier comparison
$ip1 = [IPAddress]$ip_address_1
$ip2 = [IPAddress]$ip_address_2
$net_mask = [IPAddress]$network_mask

# Calculate the network addresses for each IP
$net1 = $ip1.Address -band $net_mask.Address
$net2 = $ip2.Address -band $net_mask.Address

# Compare the network addresses and display the result
if ($net1 -eq $net2) {
    Write-Host "yes"
} else {
    Write-Host "no"
}
