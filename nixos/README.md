# NixOS Configuration

Flake-based NixOS config using [flake-parts](https://github.com/hercules-ci/flake-parts) +
[import-tree](https://github.com/vic/import-tree) for automatic module discovery, and
[home-manager](https://github.com/nix-community/home-manager) for user-level configuration.

---

## Directory Structure

```
nixos/
├── flake.nix                        # Inputs + flake-parts wiring; lists the host files
├── flake.lock                       # Pinned input versions
├── hosts/                           # One directory per machine
│   ├── kratos/
│   │   ├── configuration.nix        # hostName + users literals, module list, system config
│   │   ├── hardware-configuration.nix
│   │   └── crow-local.pem
│   └── atlas/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── pkgs/                            # Local packages
│   └── gameshell/
├── system/                          # NixOS system modules (auto-imported by import-tree)
│   ├── base/
│   │   └── system-core.nix          # System packages available to all users
│   ├── desktop/                     # sway, i3wm, plasma6, sddm, removable-media
│   ├── gaming/
│   │   └── steam.nix
│   ├── home/
│   │   └── home.nix                 # flake.lib.mkHome / mkHomesFor + homeConfigurations option
│   ├── locale/
│   │   └── localization_swe.nix     # Swedish locale/timezone
│   └── programs/
│       └── languagetool.nix
└── hm/                              # Home-manager config (NOT auto-imported)
    ├── users/
    │   ├── erik/
    │   │   ├── default.nix          # Base profile: shell, git, vim, nano, common packages
    │   │   ├── kratos.nix           # Desktop overlay: GUI apps, sway, neovim, vscode, alacritty
    │   │   └── atlas.nix            # VM overlay: docker-compose, atuin
    │   └── maria/
    │       ├── default.nix
    │       └── kratos.nix
    └── modules/                     # Reusable HM modules
        ├── shell/                   # bash (PS1, aliases), git, fzf, zoxide
        ├── programs/                # alacritty, neovim, vim, vscode, nano, firefox, finna, gameshell
        └── desktop/
            └── sway.nix             # User sway packages + symlinks sway_config/sway_bar.sh
```

## Host naming

Each host writes its name once, at the top of `hosts/<host>/configuration.nix`:

```nix
hostName = "kratos";
users = ["erik" "maria"];
```

The flake output attribute, `networking.hostName`, and the host's
`<user>@<host>` home-manager configurations all derive from those two lines,
so `rg 'hostName = '` lists every host. Renaming a host means editing the
literal, `git mv`-ing the host directory and the matching
`hm/users/<user>/<host>.nix` profiles, and updating the import path in
`flake.nix`.

**Key rule**: anything under `system/` is auto-imported by import-tree as a flake-parts module.
`hm/` lives outside `system/` intentionally — it's plain HM config, not flake-parts modules.

New `.nix` files added to `system/` must be **`git add`ed** before rebuilding, or Nix won't see them.

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
sudo nixos-rebuild switch --flake .#kratos
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
sudo nixos-rebuild switch --flake .#kratos
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
| Available system-wide (all users) | `system/base/system-core.nix` |
| Your user packages (desktop) | `hm/users/erik/kratos.nix` → `home.packages` |
| Your user packages (VM) | `hm/users/erik/atlas.nix` → `home.packages` |
| Unstable packages | Use `pkgs-unstable.<name>` — already available as `extraSpecialArgs` |

---

## Adding a New Module

1. Create a `.nix` file anywhere under `system/`
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
| `kratos` | Desktop, Sway WM, full GUI stack | 26.05 |
| `atlas` | Headless VM, Docker, NFS mounts | 23.11 |

---

## Standalone Home-Manager (non-NixOS)

On any machine with Nix installed:

```sh
git clone <repo> ~/dotfiles
nix run home-manager -- switch --flake ~/dotfiles/nixos#erik
```

This activates shell, git, editors, and program configs without touching system configuration.
