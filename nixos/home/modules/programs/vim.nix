{config, ...}: {
  home.file.".vimrc".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/linux/vim_config";
}
