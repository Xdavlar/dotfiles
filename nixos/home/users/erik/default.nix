{pkgs, ...}: {
  imports = [
    ../../modules/shell/bash.nix
    ../../modules/shell/git.nix
    ../../modules/programs/vim.nix
    ../../modules/programs/nano.nix
  ];

  home.username = "erik";
  home.homeDirectory = "/home/erik";

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fastfetch
    fzf
    ripgrep
    shellcheck
    tldr
    tree
  ];
}
