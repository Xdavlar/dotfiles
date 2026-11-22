{...}: {
  boot.loader.systemd-boot.enable = true;

  nixpkgs.config.allowUnfree = true;

  services = {
    sshd.enable = true;
    tailscale.enable = true;
    vscode-server.enable = true;
    cron = {
      enable = true;
      systemCronJobs = [
        "0 0 * * * root docker image prune -a -f"
      ];
    };
  };

  virtualisation.docker.enable = true;

  localization_swe.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "monthly";
  };

  users.users.erik = {
    isNormalUser = true;
    home = "/home/erik";
    extraGroups = ["wheel" "docker"];
  };

  fileSystems = {
    "/mnt/Synology/download" = {
      device = "192.168.0.107:/volume1/downloads";
      fsType = "nfs";
      options = ["defaults" "nofail" "nfsvers=4" "x-systemd.automount"];
    };
    "/mnt/Synology/media" = {
      device = "192.168.0.107:/volume1/media";
      fsType = "nfs";
      options = ["defaults" "nofail" "nfsvers=4" "x-systemd.automount"];
    };
    "/mnt/Synology/CAD" = {
      device = "192.168.0.107:/volume1/CAD";
      fsType = "nfs";
      options = ["defaults" "nofail" "nfsvers=4" "x-systemd.automount"];
    };
  };

  system.stateVersion = "23.11";
}
