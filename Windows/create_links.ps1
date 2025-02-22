function main {
    $usr_folder = $env:UserProfile

    create_symlink "GlazeVM" "glazewm\config.yaml" "$usr_folder\.glzr\glazewm\config.yaml" 
    create_symlink "Zebar" "zebar\config.yaml" "$usr_folder\.glzr\zebar\config.yaml"
}

function create_symlink {
    param (
        [string]$name,
        [string]$source_path,
        [string]$target_path,
        [bool]$verbose = $false
    )

    $source = (Resolve-Path $source_path).Path
    $target = $target_path

    # Ensure the source directory exists
    $sourceDir = Split-Path -Parent $source
    if (-Not (Test-Path $sourceDir)) {
        Write-Warning "Source directory does not exist: $sourceDir"
    }
    
    # Remove existing link if it exists
    if (Test-Path $target) {
        # Check if the target is a file or symbolic link
        if ((Get-Item $target).PSIsContainer -eq $false) {
            if ($verbose) { Write-Host "Removing existing link: $target" }
            Remove-Item -Force $target
        }
    }

    # Create symbolic link
    if ($verbose) {Write-Host "Creating symbolic link from $source to $target"}
    New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null

    Write-Host "$name link created successfully!"
}

# Call main function after definitions
main