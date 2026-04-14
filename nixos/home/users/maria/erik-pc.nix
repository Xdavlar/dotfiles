{pkgs-unstable, ...}: {
  imports = [./default.nix];

  home.stateVersion = "25.11";

  home.packages = [pkgs-unstable.firefox];
}
