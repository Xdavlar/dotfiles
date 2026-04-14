# Dotfiles

My personal dotfiles and NixOS configuration.

## Structure

- `nixos/` — NixOS flake config (flake-parts + import-tree)
  - `flake.nix` — inputs: nixpkgs, nixpkgs-unstable, home-manager, flake-parts, import-tree
  - `modules/` — NixOS system modules (auto-imported by import-tree)
    - `base/` — system-core packages
    - `configurations/` — per-host NixOS configurations (erik-pc, nixos-vm-docker)
    - `desktop/` — sway, i3wm (system-level only)
    - `home/` — flake-parts glue for home-manager
    - `locale/` — Swedish localization
  - `home/` — home-manager user config (not auto-imported)
    - `users/erik/` — per-host user profiles (default, erik-pc, nixos-vm-docker)
    - `modules/` — reusable HM modules (shell, programs, desktop)
  - `hosts/` — hardware-configuration.nix per host
- `linux/` — source config files symlinked by home-manager (sway, alacritty, neovim, vim)
- `scripts/` — utility scripts
- `Windows/` — Windows config

## Setup

### NixOS

1. Clone repo: `git clone <repo> ~/dotfiles`
2. Rebuild: `sudo nixos-rebuild switch --flake ~/dotfiles/nixos#<host>`
3. Set git identity:
   ```sh
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```

### Standalone (any machine with Nix)

```sh
git clone <repo> ~/dotfiles
nix run home-manager -- switch --flake ~/dotfiles/nixos#erik
```

## Hosts

| Host | Description |
|------|-------------|
| `erik-pc` | Desktop (sway, full GUI stack) |
| `nixos-vm-docker` | Headless VM (docker, NFS mounts) |
