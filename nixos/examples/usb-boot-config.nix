{
  config,
  pkgs,
  options,
  ...
}: let
  hostname = "erik-pc"; # to alllow per-machine config
in {
  networking.hostName = hostname;

  imports = [
    /etc/nixos/hardware-configuration.nix
    (/home/erik/nixosModules + "/${hostname}.nix")
  ];

  # Trying to solve USB-C mounting issues
  boot.initrd.kernelModules = ["usb_storage" "uas" "sd_mod"];
  # hardware.enableAllHardware = true;
  boot.kernelParams = [ "rootdelay=5" ];

  system.stateVersion = "23.11";
}
