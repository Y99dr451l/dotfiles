#!/bin/zsh
up=$(uptime -p)
days=$(printf '%s\n' "$up" | grep -oE '[0-9]+ day' | cut -d' ' -f1)
hours=$(printf '%s\n' "$up" | grep -oE '[0-9]+ hour' | cut -d' ' -f1)
mins=$(printf '%s\n' "$up" | grep -oE '[0-9]+ minute' | cut -d' ' -f1)
printf '{ "text": "%d:%02d:%02d / %s", "tooltip": "%s" }' "${days:-0}" "${hours:-0}" "${mins:-0}" "$(date +%H:%M)" "$(date +%a,\ %d/%m/%Y)"