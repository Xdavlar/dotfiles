#!/usr/bin/env bash

# Source shared symlink utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/symlink-utils.sh"

# Main script execution starts here

create_symlink $SCRIPT_DIR/modules/erik-pc.nix $HOME/nixosModules/erik-pc.nix
# Rest of nix-files doesn't have to be symlinked. "nixos-rebuild" follows them "here" automatically
create_symlink $SCRIPT_DIR/scripts/rebuild-nixos $HOME/bin/rebuild-nixos
