{ ... }: {
  flake.nixosModules.sway = { pkgs, lib, config, ... }: {
    options.sway.enable = lib.mkEnableOption "enables sway window manager";

    config = lib.mkIf config.sway.enable {
      environment.systemPackages = with pkgs; [
        grim
        slurp
        wl-clipboard
        mako
        rofi-unwrapped
        tuigreet
      ];

      services.xserver.enable = true;

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
  };
}
