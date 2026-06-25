{inputs, ...}: let
  mkHome = {
    system ? "x86_64-linux",
    modules,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        claude-code = inputs.claude-code.packages.${system}.default;
        finna = inputs.finna.packages.${system}.default;
      };
      inherit modules;
    };
in {
  flake.homeConfigurations = {
    "erik@erik-pc" = mkHome {modules = [../../hm/users/erik/erik-pc.nix];};
    "erik@nixos-vm-docker" = mkHome {modules = [../../hm/users/erik/nixos-vm-docker.nix];};
    "maria@erik-pc" = mkHome {modules = [../../hm/users/maria/erik-pc.nix];};
  };
}
