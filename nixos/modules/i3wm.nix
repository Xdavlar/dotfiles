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

  config = lib.mkIf config.i3wm.enable {
    environment.pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw
    services.xserver = {
      enable = true;
      layout = "se";
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };

      displayManager = {
        sddm.enable = true;
        defaultSession = "xfce+i3";
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu #application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock #default i3 screen locker
          i3blocks #if you are planning on using i3blocks over i3status
        ];
      };
    };
  };
}
