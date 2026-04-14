{config, pkgs, ...}: {
  home.packages = [ pkgs.alacritty ];

  xdg.configFile."alacritty/alacritty.toml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/linux/alacritty.toml";
}
