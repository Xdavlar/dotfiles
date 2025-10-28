# The Sway configuration file in ~/.config/sway/config calls this script.

# Produces "21 days", for example
uptime_formatted=$(uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %F %H:%M")

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')

ram_percent=$(free | awk '/^Mem:/ {printf "%.0f%%", $3/$2 * 100}')

disk_percent=$(df -h / | awk 'NR==2 {print $5}')

amd_cpu_temp=$(cat /sys/class/hwmon/hwmon1/temp1_input | head -1 | awk '{printf "%.1f°C", $1/1000}')

network_ip=$(ip route get 1.1.1.1 | awk '{print $7}')

linux_version=$(uname -r | cut -d '-' -f1)

# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 🔈 🎞️ ⛃ ⛁ 🌡️ 🌐\|
printf "🔈 %s | ⛃ %s | 🎞️ %s | %s ↑ | 🌡️ %s | 🌐 %s | %s 🐧 | %s" \
    "$volume" \
    "$disk_percent" \
    "$ram_percent" \
    "$uptime_formatted" \
    "$amd_cpu_temp" \
    "$network_ip" \
    "$linux_version" \
    "$date_formatted" \
    