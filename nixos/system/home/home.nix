{
  inputs,
  lib,
  flake-parts-lib,
  ...
}: let
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
          # bitwarden-desktop still pins electron-39.8.10 (EOL) in both channels
          config.permittedInsecurePackages = ["electron-39.8.10"];
        };
        claude-code = inputs.claude-code.packages.${system}.default;
        finna = inputs.finna.packages.${system}.default;
      };
      inherit modules;
    };
in {
  # flake-parts does not declare `flake.homeConfigurations`, so without an
  # option for it only one module could ever define it. Declaring it lets each
  # host contribute its own users' configurations.
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    homeConfigurations = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = {};
    };
  };

  config.flake.lib = {
    inherit mkHome;

    # Builds the "<user>@<host>" home configurations for one host, each from
    # hm/users/<user>/<host>.nix. Hosts call this from their own file.
    mkHomesFor = hostName: users:
      builtins.listToAttrs (map (user: {
          name = "${user}@${hostName}";
          value = mkHome {modules = [(../../hm/users + "/${user}/${hostName}.nix")];};
        })
        users);
  };
}
