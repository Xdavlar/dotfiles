{
  config,
  pkgs,
  options,
  ...
}: {
  # Add aliases for bash
  programs.bash.shellAliases = {
    ll = "ls -la";
    comp-sleep = "systemctl suspend";
    comp-hib = "systemctl hibernate";
    compose-restart = "docker-compose down && docker-compose up -d";
  };
}
