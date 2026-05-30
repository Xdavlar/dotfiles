{pkgs-unstable, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs-unstable.firefox;
    configPath = ".mozilla/firefox";
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
