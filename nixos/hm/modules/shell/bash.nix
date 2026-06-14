{...}: {
  programs.bash = {
    enable = true;
    initExtra = ''
      export PS1="\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\W]\$\[\033[0m\] "
      PATH=~/bin:$PATH
      EDITOR=vim

      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      find_large_files() {
        find . -type f -printf '%s %p\n' | sort -rn | head -''${1:-10}
      }
    '';
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ls = "ls --color=auto";
      ll = "ls -lhF";
      la = "ls -lhAF";
      l = "ls -CF";
      lsd = "ls -d */";
      rm = "rm -i";
      grep = "grep --color=auto";
      df = "df -h";
      du = "du -h";
      free = "free -h";
      mkdir = "mkdir -pv";
      cls = "clear";
      compose-hardreset = "docker-compose down && docker-compose up -d";
      comp-sleep = "systemctl suspend";
      comp-hib = "systemctl hibernate";
      nix-shell-unstable = "nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
      boot-time-blame = "systemd-analyze blame";
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos#$(hostname)";
      hm-switch = "home-manager switch -b backup --flake ~/dotfiles/nixos#$(whoami)@$(hostname)";
      start-time-blame = "systemd-analyze blame --user";
      me = "echo $(whoami)@$(hostname)";
      vf = "vim $(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')";
    };
  };
}
