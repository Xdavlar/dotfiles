{ ... }: {
  flake.nixosModules.system-core = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      alejandra
      fastfetch
      fzf
      git
      git-lfs
      ripgrep
      tldr
      tree
      vim
      wget
    ];
  };
}
