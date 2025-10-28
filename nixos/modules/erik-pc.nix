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
  ];

  vscode.enable = true;
  localization_swe.enable = true;
  sway.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  services.xserver = {
    xkb.layout = "se";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pulseaudio.support32Bit = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.erik = {
    isNormalUser = true;
    description = "erik";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      # OS
      nautilus
      git
      tldr
      wmctrl
      alacritty

      # Programs
      gnome-sound-recorder
      cheese
      unstable.discord
      unstable.firefox
      unstable.obsidian
      unstable.bitwarden-desktop
      unstable.signal-desktop

      # Libraries
      libnotify # Needed for (notify-send)
      # nerdfonts
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.noto
      nerd-fonts.hack
      nerd-fonts.ubuntu
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To seaopenglrch, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      alejandra
    ];

    interactiveShellInit = ''
      export PS1="\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u:\W]\$\[\033[0m\] "
      PATH=~/bin:$PATH
      EDITOR=vim
    '';
  };

  programs = {
    bash.shellAliases = lib.mkForce {
      lock="swaylock -l -i ~/Pictures/bg-city.jpg 2>/dev/null";
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
