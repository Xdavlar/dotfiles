#!/usr/bin/env bash
# Run once on a new machine to wire up the NixOS flake.
# After this, `sudo nixos-rebuild switch` will use this flake automatically.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo ln -sf "$SCRIPT_DIR/flake.nix" /etc/nixos/flake.nix
echo "Symlinked $SCRIPT_DIR/flake.nix -> /etc/nixos/flake.nix"
echo "You can now run: sudo nixos-rebuild switch"
