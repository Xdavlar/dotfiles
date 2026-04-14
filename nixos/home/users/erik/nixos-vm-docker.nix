{pkgs, ...}: {
  imports = [./default.nix];

  home.stateVersion = "23.11";

  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos#nixos-vm-docker";
  };

  home.packages = with pkgs; [
    atuin
    docker-compose
    libnotify
    mako
  ];
}
