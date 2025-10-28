{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <unstable> {
    config = config.nixpkgs.config;
  };
in {
  options = {
    vscode.enable = lib.mkEnableOption "enables vscode with extensions";
  };

  config = lib.mkIf config.vscode.enable {
    environment = {
      systemPackages = with pkgs; [
        # VSCode
        vscode
        vscode-extensions.bbenoist.nix
        vscode-extensions.naumovs.color-highlight
      ];
    };
  };
}
