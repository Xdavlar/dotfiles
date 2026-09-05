#!/usr/bin/env bash
#
# GameShell writes into its own root directory while playing (World/, .config/,
# .tmp/, .bin/, .sbin/, locale/), so it cannot run from the read-only store
# path. Seed a writable copy under XDG_DATA_HOME and always resume there.

set -euo pipefail

PRISTINE="@share@"
VERSION="@version@"

STATE="${XDG_DATA_HOME:-$HOME/.local/share}/gameshell"
GAME="$STATE/game"

# The parts the package owns. Replaced wholesale on upgrade; everything else in
# $GAME is game state and must survive.
IMMUTABLE=(lib missions scripts i18n man utils start.sh)

seed() {
  mkdir -p "$GAME"
  for item in "${IMMUTABLE[@]}"; do
    rm -rf "${GAME:?}/$item"
    if [ -e "$PRISTINE/$item" ]; then
      cp -R "$PRISTINE/$item" "$GAME/$item"
    fi
  done
  chmod -R u+w "$GAME"
  printf '%s\n' "$PRISTINE" >"$GAME/.gsh_origin"
}

case "${1-}" in
  --reset)
    rm -rf "$STATE"
    echo "GameShell progress reset."
    exit 0
    ;;
  --version)
    echo "gameshell $VERSION"
    exit 0
    ;;
esac

if [ ! -e "$GAME/.gsh_origin" ]; then
  seed
elif [ "$(cat "$GAME/.gsh_origin")" != "$PRISTINE" ]; then
  echo "Updating GameShell in $GAME (progress is kept)..." >&2
  seed
fi

# -C means "continue the previous game"; without it start.sh asks whether to
# wipe the save data on every launch. It is ignored when there is no save yet.
exec bash "$GAME/start.sh" -C "$@"
