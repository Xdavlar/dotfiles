{ ... }: {
  flake.nixosModules.system-core = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      alejandra
      fastfetch
      fzf
      git
      git-lfs
      htop
      ripgrep
      shellcheck
      tldr
      tree
      vim
      wget
    ];
  };
}
