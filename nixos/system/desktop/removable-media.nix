{...}: {
  flake.nixosModules.removable-media = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.removable-media.enable =
      lib.mkEnableOption "user-mountable removable media (SD cards, USB sticks)";

    config = lib.mkIf config.removable-media.enable {
      # DBus service that lets logged-in users mount removable drives without
      # sudo. Mounts land in /run/media/$USER/<label> and are owned by the
      # mounting user, so no root-owned files under /mnt.
      services.udisks2.enable = true;

      # Lets GIO applications (nautilus, gtk file chooser) see and mount drives.
      services.gvfs.enable = true;

      # Write support for NTFS sticks; exfat is in-kernel but needs userspace
      # tools for fsck/mkfs.
      boot.supportedFilesystems = {
        ntfs = true;
        exfat = true;
      };

      environment.systemPackages = with pkgs; [
        udisks # udisksctl, for mounting from the shell
        exfatprogs
      ];
    };
  };
}
