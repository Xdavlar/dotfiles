{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [./default.nix];

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    atuin
    docker-compose
    libnotify
    mako
    nvim
    pkgs-unstable.claude-code
    zellij
  ];
}
