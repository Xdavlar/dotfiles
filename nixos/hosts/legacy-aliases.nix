# TEMPORARY: re-exports the pre-rename attribute names so `rebuild` and
# `hm-switch` -- which interpolate $(hostname) -- keep resolving between the
# nixos-rebuild switch and the reboot that makes the new hostname live.
#
# Delete this file and its import in flake.nix once both kratos and atlas have
# rebooted under their new names.
{config, ...}: {
  flake.nixosConfigurations = {
    erik-pc = config.flake.nixosConfigurations.kratos;
    nixos-vm-docker = config.flake.nixosConfigurations.atlas;
  };

  flake.homeConfigurations = {
    "erik@erik-pc" = config.flake.homeConfigurations."erik@kratos";
    "maria@erik-pc" = config.flake.homeConfigurations."maria@kratos";
    "erik@nixos-vm-docker" = config.flake.homeConfigurations."erik@atlas";
  };
}
