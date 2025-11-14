{
  pkgs,
  lib,
  config,
  ...
}: {
  options.i3wm = {
    enable = lib.mkEnableOption "i3 window manager";

    enableDisplayManager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable SDDM display manager.
        Set to false if you want to manage the display manager separately
        or use i3 without a graphical login manager.
      '';
    };
  };

  config = lib.mkIf config.i3wm.enable {
    # Required for i3 to find executables in /libexec
    environment.pathsToLink = lib.mkIf config.i3wm.enableDisplayManager ["/libexec"];

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

      # SDDM display manager (optional)
      displayManager = lib.mkIf config.i3wm.enableDisplayManager {
        sddm.enable = true;
        defaultSession = "xfce+i3";
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
        ];
      };
    };
  };
}
