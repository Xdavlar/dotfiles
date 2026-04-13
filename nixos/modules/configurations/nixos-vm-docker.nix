{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.nixos-vm-docker = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.nixosModules.system-core
      config.flake.nixosModules.aliases
      ../../hosts/nixos-vm-docker/hardware-configuration.nix
      inputs.nixos-vscode-server.nixosModules.default
      ({pkgs, ...}: {
        boot.loader.systemd-boot.enable = true;

        nixpkgs.config.allowUnfree = true;

        services = {
          sshd.enable = true;
          tailscale.enable = true;
          vscode-server.enable = true;
          cron = {
            enable = true;
            systemCronJobs = [
              "0 0 * * * root docker image prune -a -f"
            ];
          };
        };

        virtualisation.docker.enable = true;

        console.keyMap = "sv-latin1";

        users.users.erik = {
          isNormalUser = true;
          home = "/home/erik";
          extraGroups = ["wheel" "docker"];
          packages = with pkgs; [
            docker-compose
            atuin
            libnotify
            mako
          ];
        };

        programs.nano.nanorc = ''
          set nowrap
          set tabstospaces
          set tabsize 2
          set autoindent
          set linenumbers
        '';

        environment.interactiveShellInit = ''
          export PS1="\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u:\W]\$\[\033[0m\] "
          PATH=~/bin:$PATH
        '';

        fileSystems = {
          "/mnt/Synology/download" = {
            device = "nas.crow.local:/volume1/downloads";
            fsType = "nfs";
            options = ["defaults" "nofail" "nfsvers=4" "x-systemd.automount"];
          };
          "/mnt/Synology/media" = {
            device = "nas.crow.local:/volume1/media";
            fsType = "nfs";
            options = ["defaults" "nofail" "nfsvers=4" "x-systemd.automount"];
          };
          "/mnt/Synology/CAD" = {
            device = "nas.crow.local:/volume1/CAD";
            fsType = "nfs";
            options = ["defaults" "nofail" "nfsvers=4" "x-systemd.automount"];
          };
        };

        system.stateVersion = "23.11";
      })
    ];
  };
}
