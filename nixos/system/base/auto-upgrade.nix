{inputs, ...}: {
  # Nightly: git pull, flake update, nixos-rebuild switch, then home-manager switch.
  # flake.lock changes stay local to the host and are reset before each pull.
  flake.nixosModules.auto-upgrade = {
    config,
    lib,
    pkgs,
    ...
  }: let
    user = "erik";
    repo = "/home/${user}/dotfiles";
    flakeDir = "${repo}/nixos";
    host = config.networking.hostName;
    hm = inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager;
    asUser = cmd: "${pkgs.util-linux}/bin/runuser -l ${user} -c ${lib.escapeShellArg cmd}";
    inputsToUpdate = ["claude-code" "finna" "flake-parts" "home-manager" "import-tree" "nixos-vscode-server" "nixpkgs" "nixpkgs-unstable" "noctalia"];
  in {
    system.autoUpgrade = {
      enable = true;
      flake = "${flakeDir}#${host}";
      upgrade = false;
      operation = "switch";
      dates = "04:00";
      randomizedDelaySec = "30min";
      persistent = true;
      allowReboot = false;
    };

    systemd.services.nixos-upgrade = {
      path = [pkgs.git pkgs.openssh config.nix.package];
      # Run as the user: they own the repo and the GitHub SSH key
      preStart = ''
        ${asUser "cd ${repo} && git checkout -- nixos/flake.lock && git pull --ff-only"}
        ${asUser "cd ${flakeDir} && nix flake update ${lib.concatStringsSep " " inputsToUpdate}"}
      '';
      postStart = ''
        ${asUser "${hm}/bin/home-manager switch --flake ${flakeDir}#${user}@${host}"}
      '';
    };
  };
}
