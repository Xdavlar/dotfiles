{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.erik-pc = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.nixosModules.system-core
      config.flake.nixosModules.localization_swe
      config.flake.nixosModules.sway
      config.flake.nixosModules.sddm
      config.flake.nixosModules.plasma6
      config.flake.nixosModules.i3wm
      config.flake.nixosModules.home-manager-erik
      ../../hosts/erik-pc/hardware-configuration.nix
      ({pkgs, ...}: {
        nix.settings.download-buffer-size = 524288000;

        localization_swe.enable = true;
        sway.enable = true;
        sddm.enable = true;
        plasma6.enable = true;

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
        };

        users.users.maria = {
          isNormalUser = true;
          description = "maria";
          extraGroups = ["networkmanager"];
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

        programs.dconf.enable = true;

        services.openssh.enable = true;

        home-manager.users.erik = import ../../home/users/erik/erik-pc.nix;
        home-manager.users.maria = import ../../home/users/maria/erik-pc.nix;

        system.stateVersion = "25.11";
      })
    ];
  };
}
