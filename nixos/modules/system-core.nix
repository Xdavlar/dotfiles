{
  config,
  pkgs,
  options,
  ...
}: {
  # I want this packets to exist on all machines
  environment = {
    systemPackages = with pkgs; [
      alejandra
      git
      git-lfs
      tldr
      fastfetch
      ripgrep
      fzf
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
    ];
  };
}
