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
      rofi-wayland # launcher, replaces wmenu
    ];

    # Enable the gnome-keyring secrets vault.
    # Will be exposed through DBus to programs willing to store secrets.
    services.gnome.gnome-keyring.enable = true;

    # enable Sway window manager
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
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
  };
}
