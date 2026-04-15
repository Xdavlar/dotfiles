{config, pkgs, ...}: {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
    rofi-unwrapped
  ];

  xdg.configFile."sway/config".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/linux/sway_config";

  xdg.configFile."sway/sway_bar.sh".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/linux/sway_bar.sh";
}
