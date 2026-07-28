#!/usr/bin/env bash

current_profile="$(powerprofilesctl get 2>/dev/null)"
options="󱐋  Performance\n  Balanced\n󰌪  Power-Saver"
chosen="$(echo -e "$options" | rofi -dmenu -i -p "Power" -mesg "Current: $current_profile")"

case "$chosen" in
    "󱐋  Performance") powerprofilesctl set performance ;;
    "  Balanced") powerprofilesctl set balanced ;;
    "󰌪  Power-Saver") powerprofilesctl set power-saver ;;
esac
