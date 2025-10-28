#!/bin/bash

# Function to create a symlink from source to destination
# Usage: create_symlink <source_path> <destination_path>
create_symlink() {
    local source="$1"
    local destination="$2"
    
    # Check if correct number of arguments provided
    if [ $# -ne 2 ]; then
        echo "Error: create_symlink requires exactly 2 arguments"
        echo "Usage: create_symlink <source_path> <destination_path>"
        return 1
    fi
    
    # Convert to absolute paths
    source=$(realpath -m "$source")
    destination=$(realpath -m "$destination")
    
    # Check if source file exists
    if [ ! -e "$source" ]; then
        echo "Error: Source file does not exist: $source"
        return 1
    fi
    
    # Check if destination already exists
    if [ -e "$destination" ] || [ -L "$destination" ]; then
        # Check if it's already a symlink pointing to the correct source
        if [ -L "$destination" ] && [ "$(readlink -f "$destination")" = "$source" ]; then
            echo "✓ Symlink already exists and points to correct location: $destination -> $source"
            return 0
        fi
        
        echo "Warning: Destination already exists: $destination"
        read -p "Do you want to backup and replace it? (y/n) " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Create backup
            backup="${destination}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$destination" "$backup"
            echo "Created backup: $backup"
        else
            echo "Skipping: $destination"
            return 1
        fi
    fi
    
    # Create parent directory if it doesn't exist
    destination_dir=$(dirname "$destination")
    if [ ! -d "$destination_dir" ]; then
        echo "Creating directory: $destination_dir"
        mkdir -p "$destination_dir"
    fi
    
    # Create the symlink
    ln -s "$source" "$destination"
    
    if [ $? -eq 0 ]; then
        echo "✓ Created symlink: $destination -> $source"
        return 0
    else
        echo "Error: Failed to create symlink"
        return 1
    fi
}

# Main script execution starts here
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$HOME/dotfiles/"
LINUX_DIR="$DOTFILES_DIR/linux"

# Include all gitaliases
git config --global include.path $LINUX_DIR/git_alias

# Add bash-aliases to the .bashrc
if ! grep -q "source.*shell_aliases" ~/.bashrc; then
    echo -e "\n# Load custom aliases\n[ -f $LINUX_DIR/shell_aliases ] && source $LINUX_DIR/shell_aliases" >> ~/.bashrc
    echo "✓ Added shell_aliases to .bashrc"
else
    echo "✓ shell_aliases already sourced in .bashrc"
fi

# Create symlinks
create_symlink $LINUX_DIR/sway_config $HOME/.config/sway/config
create_symlink $LINUX_DIR/vim_config $HOME/.vimrc

echo "Dotfiles setup complete!"