{
  config,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  flake.nixosConfigurations.erik-pc = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit pkgs-unstable;};
    modules = [
      config.flake.nixosModules.system-core
      config.flake.nixosModules.aliases
      config.flake.nixosModules.localization_swe
      config.flake.nixosModules.vscode
      config.flake.nixosModules.sway
      config.flake.nixosModules.i3wm
      /etc/nixos/hardware-configuration.nix
      ({
        pkgs,
        lib,
        pkgs-unstable,
        ...
      }: {
        nix.settings.download-buffer-size = 524288000;

        vscode.enable = true;
        localization_swe.enable = true;
        sway.enable = true;

        networking.hostName = "erik-pc";

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.initrd.kernelModules = ["usb_storage" "uas" "sd_mod"];
        boot.kernelModules = ["kvm-amd"];
        boot.kernelParams = ["rootdelay=5"];

        hardware.graphics.enable = true;

        networking.networkmanager.enable = true;

        console.keyMap = "sv-latin1";

        services.printing.enable = true;

        virtualisation.docker.enable = true;

        services.pulseaudio.enable = false;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
        security.rtkit.enable = true;

        services.dbus.implementation = "broker";
        services.gnome.gnome-keyring.enable = true;
        services.tailscale.enable = true;

        users.users.erik = {
          isNormalUser = true;
          description = "erik";
          extraGroups = ["networkmanager" "wheel" "docker" "kvm"];
          packages = with pkgs; [
            # OS
            alacritty
            dbus
            localsend
            nautilus
            wmctrl

            # Programs
            cheese
            discord
            docker-compose
            drawio
            headsetcontrol
            libreoffice
            pandoc
            pinta
            python314
            qemu_kvm
            shellcheck
            spotify
            texliveSmall
            tree
            unzip
            zathura
            pkgs-unstable.discord
            pkgs-unstable.firefox
            pkgs-unstable.google-chrome
            pkgs-unstable.obsidian
            pkgs-unstable.bitwarden-desktop
            pkgs-unstable.signal-desktop
            pkgs-unstable.claude-code

            # Neovim
            fd
            fzf
            gcc
            lazygit
            ripgrep
            tree-sitter
            pkgs-unstable.neovim

            # Libraries
            libnotify
          ];
        };

        security.pki.certificateFiles = [
          ../../hosts/erik-pc/crow-local.pem
        ];

        nixpkgs.config.allowUnfree = true;
        nix.settings.experimental-features = ["nix-command" "flakes"];

        fonts.packages = with pkgs; [
          nerd-fonts.fira-code
          nerd-fonts.droid-sans-mono
          nerd-fonts.noto
          nerd-fonts.hack
          nerd-fonts.ubuntu
        ];

        environment.interactiveShellInit = ''
          export PS1="\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u:\W]\$\[\033[0m\] "
          PATH=~/bin:$PATH
          EDITOR=vim
        '';

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

          dconf.enable = true;
        };

        services.openssh.enable = true;

        system.stateVersion = "25.11";
      })
    ];
  };
}
