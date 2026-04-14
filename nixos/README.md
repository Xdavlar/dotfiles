# NixOS Configuration

Flake-based NixOS config using [flake-parts](https://github.com/hercules-ci/flake-parts) +
[import-tree](https://github.com/vic/import-tree) for automatic module discovery, and
[home-manager](https://github.com/nix-community/home-manager) for user-level configuration.

---

## Directory Structure

```
nixos/
├── flake.nix                        # Inputs + flake-parts wiring
├── flake.lock                       # Pinned input versions
├── hosts/                           # Per-machine hardware config
│   ├── erik-pc/
│   └── nixos-vm-docker/
├── modules/                         # NixOS system modules (auto-imported by import-tree)
│   ├── base/
│   │   └── system-core.nix          # System packages available to all users
│   ├── configurations/
│   │   ├── erik-pc.nix              # erik-pc host definition
│   │   └── nixos-vm-docker.nix      # nixos-vm-docker host definition
│   ├── desktop/
│   │   ├── sway.nix                 # Sway WM (system-level: greetd, programs.sway)
│   │   └── i3wm.nix                 # i3 WM (system-level)
│   ├── home/
│   │   └── home.nix                 # Flake-parts glue: registers HM NixOS module + homeConfigurations
│   └── locale/
│       └── localization_swe.nix     # Swedish locale/timezone
└── home/                            # Home-manager config (NOT auto-imported)
    ├── users/
    │   └── erik/
    │       ├── default.nix          # Base profile: shell, git, vim, nano, common packages
    │       ├── erik-pc.nix          # Desktop overlay: GUI apps, sway, neovim, vscode, alacritty
    │       └── nixos-vm-docker.nix  # VM overlay: docker-compose, atuin
    └── modules/                     # Reusable HM modules
        ├── shell/
        │   ├── bash.nix             # PS1, aliases, bash functions
        │   └── git.nix              # Git aliases, lfs
        ├── programs/
        │   ├── alacritty.nix        # Symlinks ../linux/alacritty.toml
        │   ├── neovim.nix           # Symlinks ../linux/lazyvim/
        │   ├── vim.nix              # Symlinks ../linux/vim_config
        │   ├── vscode.nix           # VS Code + extensions
        │   └── nano.nix             # ~/.nanorc
        └── desktop/
            └── sway.nix             # User sway packages + symlinks sway_config/sway_bar.sh
```

**Key rule**: anything under `modules/` is auto-imported by import-tree as a flake-parts module.
`home/` lives outside `modules/` intentionally — it's plain HM config, not flake-parts modules.

New `.nix` files added to `modules/` must be **`git add`ed** before rebuilding, or Nix won't see them.

---

## Updating the System

### Quick rebuild (interactive)

```sh
cd ~/dotfiles/nixos
./scripts/rebuild-nixos
```

Opens your host config in `$EDITOR`, formats on save, rebuilds, and sends a desktop notification on success.

### Manual rebuild

```sh
cd ~/dotfiles/nixos
sudo nixos-rebuild switch --flake .#erik-pc
```

### Update home-manager only (no sudo)

```sh
cd ~/dotfiles/nixos
home-manager switch --flake .#erik
```

### Update flake inputs

```sh
cd ~/dotfiles/nixos
nix flake update           # Update all inputs
nix flake update nixpkgs   # Update a single input
sudo nixos-rebuild switch --flake .#erik-pc
```

### Roll back after a bad update

```sh
sudo nixos-rebuild switch --rollback   # Revert to previous NixOS generation
home-manager generations               # List HM generations
home-manager switch --flake .#erik --switch-generation <N>
```

---

## Adding Packages

| Where | What to edit |
|-------|-------------|
| Available system-wide (all users) | `modules/base/system-core.nix` |
| Your user packages (desktop) | `home/users/erik/erik-pc.nix` → `home.packages` |
| Your user packages (VM) | `home/users/erik/nixos-vm-docker.nix` → `home.packages` |
| Unstable packages | Use `pkgs-unstable.<name>` — already available as `extraSpecialArgs` |

---

## Adding a New Module

1. Create a `.nix` file anywhere under `modules/`
2. `git add` it (required — import-tree only sees tracked files)
3. Export it as `flake.nixosModules.<name>`
4. Import it in the relevant host configuration

Example skeleton:

```nix
{ ... }: {
  flake.nixosModules.my-module = { pkgs, lib, config, ... }: {
    options.my-module.enable = lib.mkEnableOption "my module";
    config = lib.mkIf config.my-module.enable {
      # ...
    };
  };
}
```

---

## Hosts

| Host | Description | State version |
|------|-------------|---------------|
| `erik-pc` | Desktop, Sway WM, full GUI stack | 25.11 |
| `nixos-vm-docker` | Headless VM, Docker, NFS mounts | 23.11 |

---

## Standalone Home-Manager (non-NixOS)

On any machine with Nix installed:

```sh
git clone <repo> ~/dotfiles
nix run home-manager -- switch --flake ~/dotfiles/nixos#erik
```

This activates shell, git, editors, and program configs without touching system configuration.
