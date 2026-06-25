# Minima Dotfiles

A minimal and clean Hyprland or Niri setup running on CachyOS or EndeavourOS.

---

## Setup

| Component | Tool |
|---|---|
| OS | CachyOS / EndeavourOS (tested with no other DE installed) |
| WM | Hyprland [Scrolling Enabled] (or Niri) |
| Terminal | Kitty |
| App Launcher | Fuzzel |
| Panel | Waybar |
| Notification Daemon | Dunst |
| Wallpaper | swww + Waypaper |
| GTK Theme | Graphite-Dark |
| Cursor Theme | Bibata-Modern-Classic |
| Font | JetBrains Mono Nerd Font |
| Shell | Zsh |
| Display Manager | greetd + tuigreet |

---

## Installation

1. Install Hyprland or Niri and git:
   ```bash
   sudo pacman -S hyprland niri git
   ```

2. Clone the repo and run the script:
   ```bash
   git clone https://github.com/ItsChaitanyaG/minima-dotfiles.git
   cd minima-dotfiles
   chmod +x setup-minima.sh
   ./setup-minima.sh
   ```

3. Reboot once it finishes.

---

## What the script actually does

- Installs `yay` if it's missing
- Installs all supporting tools (terminal, launcher, panel, notifications, screenshot tools, theming tools, portals, and the full audio stack)
- Clones this repo and copies `hypr`, `niri`, `kitty`, `waybar`, `fuzzel`, and `dunst` configs into `~/.config/`
- Installs and applies the Graphite-Dark GTK theme and Bibata cursor theme system-wide
- Sets cursor and Qt platform environment variables
- Changes your default shell to **zsh**
- Installs and enables **greetd + tuigreet** as your display manager, disabling GDM/SDDM/LightDM if any are found

---

## Keyring & Polkit

To keep browser logins and credentials persistent across sessions (Hyprland ↔ Niri ↔ anything else), the Hyprland/Niri configs already include:

```
exec-once = /usr/lib/polkit-kde-authentication-agent-1
exec-once = gnome-keyring-daemon --start --components=secrets,pkcs11,ssh
```

No extra setup needed — this is baked into the configs in this repo.

---

## IMPORTANT — Manual Steps

- **Rofi and Swaync** are present in this repo but **not installed or copied by the script** — if you want to use these instead of Fuzzel/Dunst, copy them into `~/.config/` yourself and update the relevant `exec-once` lines in your Hyprland/Niri config.

---

## Keybinds

| Keybind | Action |
|---|---|
| `Super + T` | Open terminal (Kitty) |
| `Super + Q` | Close active window |
| `Super + M` | Exit Hyprland (uses `hyprshutdown` if available, falls back to exit) |
| `Super + E` | Open file manager (Nemo) |
| `Super + V` | Toggle floating |
| `Super + D` | Open app launcher (Fuzzel) |
| `Super + P` | Toggle pseudotile |
| `Super + Y` | Hide and Unhide Waybar |
| `Super + F` | Toggle column width (full / half) — scrolling layout |
| `Super + Shift + F` | Toggle true fullscreen |
| `Alt + Tab` | Cycle to next window |
| `Super + Tab` | Cycle to next window |
| `Super + Shift + Scroll` | Cycle through windows |
| `Super + Print` | Screenshot → save to `~/Pictures/Screenshots` |
| `Super + Ctrl + Print` | Screenshot (region select) → save & copy to clipboard |
| `Super + ←/→/↑/↓` | Move focus in direction |
| `Super + [1-0]` | Switch to workspace 1–10 |
| `Super + Shift + [1-0]` | Move active window to workspace 1–10 |
| `Super + S` | Toggle special workspace ("magic") |
| `Super + Shift + S` | Move window to special workspace |
| `Super + Scroll` | Switch to next/previous workspace |
| `Super + Left Click + Drag` | Move window |
| `Super + Right Click + Drag` | Resize window |

---



```
minima-dotfiles/
├── hypr/            # Hyprland config (Lua)
├── niri/            # Niri config (KDL)
├── kitty/           # Kitty terminal config
├── waybar/          # Waybar config
├── fuzzel/          # Fuzzel launcher config
├── dunst/           # Dunst notification config
├── rofi/            # Rofi config (manual install only)
├── swaync/          # Swaync config (manual install only)
└── setup-minima.sh  # Bootstrap script
```
