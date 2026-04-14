{pkgs, ...}: {
  imports = [
    ../../modules/shell/bash.nix
    ../../modules/programs/nano.nix
  ];

  home.username = "maria";
  home.homeDirectory = "/home/maria";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fastfetch
    fzf
    ripgrep
    tldr
    tree
  ];
}
