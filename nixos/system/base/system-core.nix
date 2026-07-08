{...}: {
  flake.nixosModules.system-core = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      alejandra
      bat
      fastfetch
      fd
      fzf
      git
      git-lfs
      htop
      ripgrep
      ripgrep-all
      shellcheck
      tldr
      tree
      vim
      wget
    ];
  };
}
