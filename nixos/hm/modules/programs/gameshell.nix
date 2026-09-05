{pkgs, ...}: {
  home.packages = [(pkgs.callPackage ../../../pkgs/gameshell {})];
}
