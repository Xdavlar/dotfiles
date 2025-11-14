{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <unstable> {
    config = config.nixpkgs.config;
  };
in {
  imports = [
    ./vscode.nix
    ./localization_swe.nix
    ./sway.nix
    ./aliases.nix
    ./system-core.nix
  ];

  # 500 MB (https://discourse.nixos.org/t/my-nixos-installation-is-stuck-in-the-download-buffer-is-full/65534/5)
  nix.settings = {
    download-buffer-size = 524288000; # 500 MiB
  };

  vscode.enable = true;
  localization_swe.enable = true;
  sway.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.erik = {
    isNormalUser = true;
    description = "erik";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      # OS
      nautilus
      wmctrl # Do I need this?
      alacritty

      # Programs
      gnome-sound-recorder
      cheese
      pandoc
      headsetcontrol
      texliveSmall
      pinta
      zathura # PDF-viewer
      unstable.discord
      unstable.firefox
      unstable.obsidian
      unstable.bitwarden-desktop
      unstable.signal-desktop

      # Neovim
      unstable.neovim
      gcc
      lazygit
      fd
      ripgrep
      fzf
      tree-sitter

      # Libraries
      libnotify # Needed for (notify-send)
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
    nerd-fonts.ubuntu
  ];

  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";
    };

    interactiveShellInit = ''
      export PS1="\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u:\W]\$\[\033[0m\] "
      PATH=~/bin:$PATH
      EDITOR=vim
    '';
  };

  programs = {
    bash.shellAliases = {
      lock = lib.mkForce "swaylock -l -i ~/Pictures/bg-city.jpg 2>/dev/null";
      pdf = "zathura";
    };

    nano.nanorc = ''
      set nowrap
      set tabstospaces
      set tabsize 2
      set autoindent
      set linenumbers
    '';
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # DONT TOUCH THIS!
  system.stateVersion = "23.11"; # Did you read the comment?
}
