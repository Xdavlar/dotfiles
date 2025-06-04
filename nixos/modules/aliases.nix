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
  };
}
