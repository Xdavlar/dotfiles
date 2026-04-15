{ ... }: {
  flake.nixosModules.sddm = { lib, config, ... }: {
    options.sddm.enable = lib.mkEnableOption "SDDM display manager";

    config = lib.mkIf config.sddm.enable {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      services.displayManager.defaultSession = "sway";
    };
  };
}
