{ finna, ... }: {
  home.packages = [ finna ];

  # Index daemon: initial scan, then live inotify watch. Keeps the GUI/TUI
  # index fresh. Re-run `finna index` after installing new apps (nix profile
  # changes don't fire inotify events).
  systemd.user.services.finna = {
    Unit.Description = "finna file index daemon";
    Service = {
      ExecStart = "${finna}/bin/finna daemon";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
