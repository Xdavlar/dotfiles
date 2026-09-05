{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  gnugrep,
  gawk,
  findutils,
  diffutils,
  gettext,
  ncurses,
  util-linux,
  man-db,
  tree,
  nano,
  procps,
  psmisc,
  less,
  file,
  which,
  gzip,
  gnutar,
}: let
  # Commands the missions teach and rely on. Prefixed onto PATH so the game
  # works the same regardless of what the player has installed.
  runtimeInputs = [
    bash
    coreutils
    gnused
    gnugrep
    gawk
    findutils
    diffutils
    gettext
    ncurses
    util-linux
    man-db
    tree
    nano
    procps
    psmisc
    less
    file
    which
    gzip
    gnutar
  ];
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "gameshell";
    # Upstream's rolling "latest" release, which is what its README and
    # Dockerfile point at. The tag moves, so pin the commit it resolved to.
    version = "0.6.0-unstable-2026-05-05";

    src = fetchFromGitHub {
      owner = "phyver";
      repo = "GameShell";
      rev = "53f470d70550c213f70b231eef102cef50d758ee";
      hash = "sha256-Gb4ESHwMt98hfjhFLUy2hnWr22/B/lMLdSkymFxJG40=";
    };

    # bash and gawk are here for patchShebangs: several scripts carry
    # `#!/bin/awk -f` and `#!/bin/sh`, neither of which exists on NixOS.
    nativeBuildInputs = [makeWrapper bash gawk];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      share=$out/share/gameshell
      mkdir -p "$share" $out/bin
      # `man` only exists on master, not in the v0.6.0 release; copy whichever
      # of these the pinned source actually ships so the pin can move freely.
      for item in lib missions scripts i18n man utils start.sh; do
        if [ -e "$item" ]; then cp -R "$item" "$share/"; fi
      done

      chmod +x "$share/start.sh" "$share"/scripts/* "$share"/utils/*

      # GSH_EXEC_DIR/GSH_EXEC_FILE are only ever set by lib/header.sh, the
      # self-extracting archive this package deliberately skips. start.sh turns
      # autosave on regardless, so completing a mission tried to write its
      # savefile to "/-save." and failed. The persistent game directory already
      # is the save, so default autosave off, and make the writer a no-op when
      # there is no archive to write back into.
      substituteInPlace "$share/start.sh" \
        --replace-fail \
          'export GSH_AUTOSAVE=1' \
          'export GSH_AUTOSAVE=''${GSH_AUTOSAVE-0}'
      substituteInPlace "$share/lib/gsh.sh" \
        --replace-fail \
          '! [ -d "$GSH_ROOT/.git" ] || return' \
          '{ ! [ -d "$GSH_ROOT/.git" ] && [ -n "$GSH_EXEC_FILE" ]; } || return'

      patchShebangs "$share"

      substitute ${./launcher.sh} $out/bin/gameshell \
        --replace-fail "@share@" "$share" \
        --replace-fail "@version@" "${finalAttrs.version}"
      chmod +x $out/bin/gameshell

      wrapProgram $out/bin/gameshell \
        --prefix PATH : ${lib.makeBinPath runtimeInputs}

      runHook postInstall
    '';

    meta = {
      description = "Game to teach the Unix shell, run natively with persistent progress";
      homepage = "https://github.com/phyver/GameShell";
      license = lib.licenses.gpl3Plus;
      mainProgram = "gameshell";
      platforms = lib.platforms.unix;
    };
  })
