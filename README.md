# Dotfiles

My personal dotfiles and NixOS configuration.

## Structure

- `nixos/` — NixOS flake config (flake-parts + import-tree)
  - `flake.nix` — inputs: nixpkgs, nixpkgs-unstable, home-manager, flake-parts, import-tree
  - `system/` — NixOS system modules (auto-imported by import-tree)
    - `base/` — system-core packages
    - `desktop/` — sway, i3wm, plasma6, sddm (system-level only)
    - `gaming/` — steam
    - `home/` — standalone home-manager configurations
    - `locale/` — Swedish localization
  - `hm/` — home-manager user config (standalone, not tied to NixOS)
    - `users/` — per-user, per-host profiles (erik, maria)
    - `modules/` — reusable HM modules (shell, programs, desktop)
  - `hosts/` — per-host NixOS configurations + hardware-configuration.nix
- `linux/` — source config files symlinked by home-manager (sway, alacritty, neovim, vim)
- `scripts/` — utility scripts
- `Windows/` — Windows config

## Setup

### NixOS + Home Manager

1. Clone repo: `git clone <repo> ~/dotfiles`
2. Rebuild NixOS: `sudo nixos-rebuild switch --flake ~/dotfiles/nixos#<host>`
3. Activate Home Manager: `nix run home-manager -- switch -b backup --flake ~/dotfiles/nixos#<user>@<host>`

NixOS and Home Manager are managed independently — NixOS handles system config, Home Manager handles user environments.

After the first activation, use the shell aliases:
- `rebuild` — rebuild NixOS
- `hm-switch` — rebuild Home Manager (auto-detects user and host)

### Standalone Home Manager (any machine with Nix)

```sh
git clone <repo> ~/dotfiles
nix run home-manager -- switch -b backup --flake ~/dotfiles/nixos#<user>@<host>
```

## Hosts

| Host | Description |
|------|-------------|
| `erik-pc` | Desktop (sway, full GUI stack) |
| `nixos-vm-docker` | Headless VM (docker, NFS mounts) |

## Home Manager Configurations

| Config | Description |
|--------|-------------|
| `erik@erik-pc` | Desktop user (GUI apps, sway, neovim, vscode) |
| `erik@nixos-vm-docker` | VM user (docker-compose, atuin) |
| `maria@erik-pc` | Desktop user (firefox) |
