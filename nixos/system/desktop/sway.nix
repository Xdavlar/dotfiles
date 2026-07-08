{...}: {
  flake.nixosModules.sway = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.sway.enable = lib.mkEnableOption "enables sway window manager";

    config = lib.mkIf config.sway.enable {
      services.xserver.enable = true;

      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
      };
    };
  };
}
