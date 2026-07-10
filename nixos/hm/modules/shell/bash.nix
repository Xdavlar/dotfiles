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
      boot-time-blame = "systemd-analyze blame";
      cls = "clear";
      comp-hib = "systemctl hibernate";
      comp-sleep = "systemctl suspend";
      compose-hardreset = "docker-compose down && docker-compose up -d";
      df = "df -h";
      du = "du -h";
      free = "free -h";
      grep = "grep --color=auto";
      hm-switch = "home-manager switch -b backup --flake ~/dotfiles/nixos#$(whoami)@$(hostname)";
      l = "ls -CF";
      la = "ls -lhAF";
      ll = "ls -lhF";
      ls = "ls --color=auto";
      lsd = "ls -d */";
      me = "echo $(whoami)@$(hostname)";
      mkdir = "mkdir -pv";
      nix-shell-unstable = "nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
      os-age = ''echo $(( ( $(date +%s) - $(date -d "$(stat --format=%w /)" +%s) ) / 86400 )) days'';
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos#$(hostname)";
      rm = "rm -i";
      start-time-blame = "systemd-analyze blame --user";
      vf = "vim $(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')";
    };
  };
}
