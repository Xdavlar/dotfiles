{pkgs, pkgs-unstable, ...}: {
  imports = [
    ./default.nix
    ../../modules/programs/alacritty.nix
    ../../modules/programs/neovim.nix
    ../../modules/programs/vscode.nix
    ../../modules/desktop/sway.nix
    ../../modules/programs/firefox.nix
  ];

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # OS
    dbus
    localsend
    nautilus
    wmctrl

    # Programs
    cheese
    docker-compose
    drawio
    flameshot
    headsetcontrol
    libreoffice
    pandoc
    pinta
    python314
    qemu_kvm
    texliveSmall
    thunderbird
    unzip
    zathura

    # Dev
    fd
    gcc
    lazygit
    tree-sitter

    # Unstable
    pkgs-unstable.bitwarden-desktop
    pkgs-unstable.claude-code
    pkgs-unstable.discord
    pkgs-unstable.google-chrome
    pkgs-unstable.obsidian
    pkgs-unstable.signal-desktop
    pkgs-unstable.spotify

    # Libraries
    libnotify
  ];

  xdg.configFile."mako/config".text = ''
    [app-name=flameshot summary="Flameshot Info"]
    invisible=1
  '';

  xdg.configFile."flameshot/flameshot.ini".text = ''
    [General]
    disabledGrimWarning=true
    showStartupLaunchMessage=false
  '';

  programs.bash.shellAliases = {
    lock = "swaylock -l -i ~/Pictures/bg-city.jpg 2>/dev/null";
    pdf = "zathura";
  };
}
