{
  config,
  pkgs,
  ...
}:
{
  boot.loader.grub.device = "/dev/sda";   # (for BIOS systems only)
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
    ];	
  };

  system.stateVersion = "23.11";
}
