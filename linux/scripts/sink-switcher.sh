#!/usr/bin/env bash
set -euo pipefail

declare -A sinks
while IFS=$'\t' read -r name desc; do
  sinks["$name"]="$desc"
done < <(
  pactl list sinks | awk '
    /^[ \t]*Name: /        { sub(/^[ \t]*Name: /, ""); name=$0 }
    /^[ \t]*Description: / { sub(/^[ \t]*Description: /, ""); print name"\t"$0 }
  '
)

default=$(pactl get-default-sink)

menu_lines=()
for name in "${!sinks[@]}"; do
  desc="${sinks[$name]}"
  prefix="  "
  [[ "$name" == "$default" ]] && prefix="→ "
  menu_lines+=("${prefix}${desc}")
done

choice=$(printf '%s\n' "${menu_lines[@]}" | rofi -dmenu -p "Audio Output" -i)
[[ -z "$choice" ]] && exit 0

choice="${choice#→ }"
choice="${choice#  }"

for name in "${!sinks[@]}"; do
  if [[ "${sinks[$name]}" == "$choice" ]]; then
    pactl set-default-sink "$name"
    while read -r input _; do
      [[ -n "$input" ]] && pactl move-sink-input "$input" "$name"
    done < <(pactl list short sink-inputs)
    command -v notify-send >/dev/null && notify-send "Audio output" "$choice"
    break
  fi
done
