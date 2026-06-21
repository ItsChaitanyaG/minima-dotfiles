#!/bin/bash

options="Shutdown\nReboot\nSuspend\nLock\nLogout"

chosen=$(echo -e "$options" | fuzzel --dmenu --prompt "Power: ")

case $chosen in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Suspend) systemctl suspend ;;
    Lock) hyprlock ;;
    Logout) hyprctl dispatch "hl.dsp.exit()" ;;
esac
