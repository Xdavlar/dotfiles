{ ... }: {
  flake.nixosModules.steam = { lib, config, ... }: {
    options.steam.enable = lib.mkEnableOption "enables Steam";

    config = lib.mkIf config.steam.enable {
      nixpkgs.config.allowUnfreePackages = [
        "steam"
        "steam-unwrapped"
      ];
      programs.steam = {
        enable = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    };
  };
}