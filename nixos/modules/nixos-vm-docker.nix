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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

      libnotify
      mako
    ];
  };

  programs = {
    bash.shellAliases = {
      comp-sleep = "systemctl suspend";
      comp-hib = "systemctl hibernate";
    };

    nano.nanorc = ''
      set nowrap
      set tabstospaces
      set tabsize 2
      set autoindent
      set linenumbers
    '';
  };

  environment.interactiveShellInit = ''
    export PS1="\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u:\W]\$\[\033[0m\] "
  '';

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
