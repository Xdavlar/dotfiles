{ ... }: {
  flake.nixosModules.vscode = { pkgs, lib, config, ... }: {
    options.vscode.enable = lib.mkEnableOption "enables vscode with extensions";

    config = lib.mkIf config.vscode.enable {
      environment.systemPackages = with pkgs; [
        vscode
        vscode-extensions.bbenoist.nix
        vscode-extensions.naumovs.color-highlight
      ];
    };
  };
}
