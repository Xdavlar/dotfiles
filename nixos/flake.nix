{
  description = "Erik's NixOS configuration";

  # To update any input use: nix flake update <input>
  inputs = {
    claude-code.url = "github:sadjow/claude-code-nix";
    finna.url = "gitlab:Davlar/finna";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixos-vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Deliberately not following nixpkgs: the upstream binary cache
    # (noctalia.cachix.org) is only valid for their own nixpkgs pin.
    noctalia.url = "github:noctalia-dev/noctalia";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: let
      m = config.flake.nixosModules;
      inherit (config.flake.lib) mkHomesFor;

      # Every host: shared modules + hosts/<name>/{configuration,hardware-configuration}.nix
      mkHost = hostName: modules:
        inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            modules
            ++ [
              ./hosts/${hostName}/hardware-configuration.nix
              ./hosts/${hostName}/configuration.nix
              # Important for all the $(hostname) configuration to work
              {networking.hostName = hostName;}
            ];
        };
    in {
      systems = ["x86_64-linux"];

      imports = [(inputs.import-tree ./system)];

      flake.nixosConfigurations = {
        # Desktop
        kratos = mkHost "kratos" [
          m.system-core
          m.localization_swe
          m.sway
          m.sddm
          m.plasma6
          m.i3wm
          m.removable-media
          m.steam
          m.languagetool
        ];

        # Home server
        atlas = mkHost "atlas" [
          m.system-core
          m.localization_swe
          m.auto-upgrade
          inputs.nixos-vscode-server.nixosModules.default
        ];
      };

      flake.homeConfigurations =
        mkHomesFor "kratos" ["erik" "maria"]
        // mkHomesFor "atlas" ["erik"];
    });
}
