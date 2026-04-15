{pkgs-unstable, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs-unstable.firefox;
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
