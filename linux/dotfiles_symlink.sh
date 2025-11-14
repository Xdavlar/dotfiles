#!/usr/bin/env bash

# Source shared symlink utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/symlink-utils.sh"

# Main script execution starts here
DOTFILES_DIR="$HOME/dotfiles"
LINUX_DIR="$DOTFILES_DIR/linux"

# Include all gitaliases
git config --global include.path $LINUX_DIR/git_alias

# Add bash-aliases to the .bashrc
if ! grep -q "source.*shell_aliases" ~/.bashrc; then
  echo -e "\n# Load custom aliases\n[ -f $LINUX_DIR/shell_aliases ] && source $LINUX_DIR/shell_aliases" >>~/.bashrc
  echo "✓ Added shell_aliases to .bashrc"
else
  echo "✓ shell_aliases already sourced in .bashrc"
fi

echo $HOME
# Create symlinks
create_symlink $LINUX_DIR/sway_bar.sh $HOME/.config/sway/sway_bar.sh
create_symlink $LINUX_DIR/sway_config $HOME/.config/sway/config
create_symlink $LINUX_DIR/vim_config $HOME/.vimrc
create_symlink $LINUX_DIR/alacritty.toml $HOME/.config/alacritty/alacritty.toml
create_symlink $LINUX_DIR/lazyvim $HOME/.config/nvim/

echo "Dotfiles setup complete!"
