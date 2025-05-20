{
  config,
  pkgs,
  options,
  ...
}: {
  # Add aliases for bash
  programs.bash.shellAliases = {
    ll = "ls -la";
  };
}
