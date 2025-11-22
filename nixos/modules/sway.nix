{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    sway.enable =
      lib.mkEnableOption "enables sway window manager";
  };

  config = lib.mkIf config.sway.enable {
    environment.systemPackages = with pkgs; [
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      mako # notification system developed by swaywm maintainer
      rofi-wayland-unwrapped # launcher, replaces wmenu
    ];

    # enable Sway window manager
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    environment.variables = {
      GTK_USE_PORTAL = 0;
      GST_PLUGIN_SYSTEM_PATH_1_0 = ["/run/current-system/sw/lib/gstreamer-1.0"];
    };

    programs.bash.shellAliases = {
      lock = "swaylock --color 000000 2>/dev/null";
    };

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "erik";
        };
        default_session = initial_session;
      };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      config = {
        sway = {
          default = lib.mkForce ["wlr" "gtk"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
        };
      };
    };
  };
}
