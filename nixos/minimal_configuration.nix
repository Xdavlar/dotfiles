{
  config,
  pkgs,
  options,
  ...
}: let
  hostname = "nixos-vm-docker";
in {
  networking.hostName = hostname;
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (/home/erik/dotfiles/nixos/modules + "/${hostname}.nix")
  ];
}
