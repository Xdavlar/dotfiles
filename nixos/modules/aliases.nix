{
  config,
  pkgs,
  options,
  ...
}: {
  # Add aliases for bash
  programs.bash.shellAliases = {
    compose-hardreset = "docker-compose down && docker-compose up -d";
    ll = "ls -la";
    comp-sleep = "systemctl suspend";
    comp-hib = "systemctl hibernate";
    nix-shell-unstable = "nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  };
}
