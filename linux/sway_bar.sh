# The Sway configuration file in ~/.config/sway/config calls this script.

# Produces "21 days", for example
uptime_formatted=$(uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %F %H:%M")

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')

audio_output=$(pactl get-default-sink | sed 's/.*\.//')

ram_percent=$(free | awk '/^Mem:/ {printf "%.0f%%", $3/$2 * 100}')

disk_percent=$(df -h / | awk 'NR==2 {print $5}')

amd_cpu_temp=$(cat /sys/class/hwmon/hwmon1/temp1_input | head -1 | awk '{printf "%.1f°C", $1/1000}')

network_ip=$(ip route get 1.1.1.1 | awk '{print $7}')

linux_version=$(uname -r | cut -d '-' -f1)

# Claude Code subscription usage (session = 5h window, week = 7d window).
# The bar only ever reads a cache file, so it never blocks. A background
# `claude -p /usage` refreshes that cache at most every $claude_ttl seconds;
# that command reports rate-limit status without spending model tokens. A
# non-blocking flock keeps concurrent bar ticks from launching duplicate
# refreshes.
claude_cache="${XDG_RUNTIME_DIR:-/tmp}/claude_usage"
claude_ttl=120
if [ ! -f "$claude_cache" ] || \
   [ "$(( $(date +%s) - $(stat -c %Y "$claude_cache") ))" -gt "$claude_ttl" ]; then
    (
        flock -n 9 || exit 0
        out=$(claude -p "/usage" 2>/dev/null) || exit 0
        s=$(printf '%s' "$out" | rg -o -r '$1' 'Current session: ([0-9]+)% used')
        w=$(printf '%s' "$out" | rg -o -r '$1' 'Current week[^:]*: ([0-9]+)% used')
        r=$(printf '%s' "$out" | rg -o -r '$1' 'Current session:.*resets [^,]+, ([0-9]{1,2}:[0-9]{2}[ap]m)')
        [ -n "$s" ] && printf '%s%% (%s) - %s%%' "$s" "${r:-?}" "$w" > "$claude_cache"
    ) 9>"${claude_cache}.lock" &
fi
if [ -f "$claude_cache" ]; then
    IFS= read -r claude_usage < "$claude_cache"
else
    claude_usage="…"
fi

# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 🔈 🎞️ ⛃ ⛁ 🌡️ 🌐\| 🤖
printf "🤖 %s | 🔈 %s (%s) | ⛃ %s | 🎞️ %s | %s ↑ | 🌡️ %s | 🌐 %s | %s 🐧 | %s" \
    "$claude_usage" \
    "$volume" \
    "$audio_output" \
    "$disk_percent" \
    "$ram_percent" \
    "$uptime_formatted" \
    "$amd_cpu_temp" \
    "$network_ip" \
    "$linux_version" \
    "$date_formatted" \
    
