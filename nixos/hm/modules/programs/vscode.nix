{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode.fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      naumovs.color-highlight
      rust-lang.rust-analyzer
      golang.go
      anthropic.claude-code
    ];
  };
}
