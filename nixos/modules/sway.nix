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
      rofi-unwrapped # launcher, replaces wmenu
      tuigreet
    ];

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = true;

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
      settings = {
        background = "$HOME/dotfiles/nixos-wallpaper-logo.jpg";
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.sway}/bin/sway";
        };
      };
    };
  };
}
