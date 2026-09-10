{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [./default.nix];

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    pkgs-unstable.claude-code
    atuin
    docker-compose
    libnotify
    mako
  ];
}
