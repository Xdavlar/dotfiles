{ ... }: {
  flake.nixosModules.sway = { lib, config, ... }: {
    options.sway.enable = lib.mkEnableOption "enables sway window manager";

    config = lib.mkIf config.sway.enable {
      services.xserver.enable = true;

      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
      };
    };
  };
}
