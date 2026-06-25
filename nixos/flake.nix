{
  description = "Erik's NixOS configuration";

  inputs = {
    claude-code.url = "github:sadjow/claude-code-nix";
    finna.url = "git+file:///home/erik/dev/search-solution";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixos-vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        (inputs.import-tree ./system)
        ./hosts/erik-pc/configuration.nix
        ./hosts/nixos-vm-docker/configuration.nix
      ];
    };
}
