{ ... }: {
  flake.nixosModules.localization_swe = { lib, config, ... }: {
    options.localization_swe.enable = lib.mkEnableOption "enables swedish localization";

    config = lib.mkIf config.localization_swe.enable {
      time.timeZone = "Europe/Stockholm";
      console.keyMap = "sv-latin1";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "sv_SE.UTF-8";
        LC_IDENTIFICATION = "sv_SE.UTF-8";
        LC_MEASUREMENT = "sv_SE.UTF-8";
        LC_MONETARY = "sv_SE.UTF-8";
        LC_NAME = "sv_SE.UTF-8";
        LC_NUMERIC = "sv_SE.UTF-8";
        LC_PAPER = "sv_SE.UTF-8";
        LC_TELEPHONE = "sv_SE.UTF-8";
        LC_TIME = "sv_SE.UTF-8";
      };
    };
  };
}
