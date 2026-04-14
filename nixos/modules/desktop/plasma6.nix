{ ... }: {
  flake.nixosModules.plasma6 = { lib, config, ... }: {
    options.plasma6.enable = lib.mkEnableOption "KDE Plasma 6 desktop environment";

    config = lib.mkIf config.plasma6.enable {
      services.desktopManager.plasma6.enable = true;
    };
  };
}
