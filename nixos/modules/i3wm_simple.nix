{
  pkgs,
  lib,
  config,
  callpackage,
  ...
}: {
  options = {
    i3vm.enable =
      lib.mkEnableOption "enables i3 window manager";
  };

  config = lib.mkIf config.i3vm.enable {
    services.xserver = {
      layout = "se";
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
        ];
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
    };
  };
}
