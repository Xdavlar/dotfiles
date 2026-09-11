{noctalia, ...}: {
  imports = [noctalia.homeModules.default];

  programs.noctalia = {
    enable = true;

    # Started by `exec noctalia` from linux/sway_config instead: the sway
    # session here never activates graphical-session.target, so the unit this
    # option installs would never be pulled in.
    systemd.enable = false;

    # Baseline only. Anything changed in the settings GUI is written to
    # ~/.local/state/noctalia/settings.toml and takes precedence over this.
    settings = {
      bar.default = {
        position = "top";
        start = ["workspaces" "active_window"];
        center = ["clock"];
        end = [
          "media"
          "tray"
          "cpu-temp"
          "ram"
          "disk"
          "volume"
          "network"
          "notifications"
          "control-center"
        ];
      };

      widget = {
        clock.format = "{:%a %F %H:%M}";

        # The three readouts sway_bar.sh used to shell out for once a second.
        cpu-temp = {
          type = "sysmon";
          stat = "cpu_temp";
        };
        ram = {
          type = "sysmon";
          stat = "ram_pct";
        };
        disk = {
          type = "sysmon";
          stat = "disk_used_pct";
          path = "/";
        };
      };

      # swaybg still owns the background (`output * bg` in sway_config);
      # without this noctalia draws its own on top.
      wallpaper.enabled = false;

      # mako is still installed and owns org.freedesktop.Notifications; two
      # daemons racing for that bus name is the easiest way to break this.
      # Flip to true when mako goes.
      notification.enable_daemon = false;
    };
  };
}
