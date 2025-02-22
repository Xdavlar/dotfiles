function main {
    $usr_folder = $env:UserProfile
    $glaze_src = "glazewm\config.yaml"
    $glaze_tar = "$usr_folder\.glzr\glazewm\config.yaml"

    Write-Host $glaze_tar
    create_symlink "GlazeVM" $glaze_src $glaze_tar
}


function create_symlink {
    param (
        [string]$name,
        [string]$source_path,
        [string]$target_path
    )

    $source = (Resolve-Path $source_path).Path
    $target = $target_path

    # Ensure the source directory exists
    $sourceDir = Split-Path -Parent $source
    if (-Not (Test-Path $sourceDir)) {
        Write-Warning "Source directory does not exist: $sourceDir"
    }
    return


    # Remove existing link if it exists
    if (Test-Path $target -or (Test-Path $target -PathType Leaf)) {
        Write-Host "Removing existing link: $target"
        Remove-Item -Force $target
    }

    # Create symbolic link
    Write-Host "Creating symbolic link from $source to $target"
    New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null

    Write-Host "$name link created successfully!"
}

# Call main function after definitions
main