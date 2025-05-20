{
  config,
  pkgs,
  ...
}: let
  modulesDirectory = "/home/erik/dotfiles/nixos/modules/";
in {
  imports = [
    (modulesDirectory + "aliases.nix")
  ];

  boot.loader.grub.device = "/dev/sda"; # (for BIOS systems only)
  boot.loader.systemd-boot.enable = true; # (for UEFI systems only)

  # Note: setting fileSystems is generally not
  # necessary, since nixos-generate-config figures them out
  # automatically in hardware-configuration.nix.
  #fileSystems."/".device = "/dev/disk/by-label/nixos";

  # Enable the OpenSSH server.
  services.sshd.enable = true;

  virtualisation.docker.enable = true;

  console.keyMap = "sv-latin1";
  users.users.erik = {
    isNormalUser = true;
    home = "/home/erik";
    extraGroups = ["wheel" "docker"];

    packages = with pkgs; [
      git
      vim
      docker-compose
      alejandra
      tldr
      atuin
    ];
  };

  fileSystems = {
    "/mnt/Synology/download" = {
      device = "ns.nas.se:/volume1/downloads";
      fsType = "nfs";
      options = ["defaults" "nofail" "nfsvers=4" "x-systemd.automount"];
    };

    "/mnt/Synology/media" = {
      device = "ns.nas.se:/volume1/media";
      fsType = "nfs";
      options = ["defaults" "nofail" "nfsvers=4" "x-systemd.automount"];
    };

    "/mnt/Synology/CAD" = {
      device = "ns.nas.se:/volume1/CAD";
      fsType = "nfs";
      options = ["defaults" "nofail" "nfsvers=4" "x-systemd.automount"];
    };
  };
  system.stateVersion = "23.11";
}
