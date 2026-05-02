# Minima Dotfiles

A minimal and clean setup running on CachyOS with KDE and Hyprland.

---

## Setup

| Component | Tool |
|---|---|
| OS | CachyOS |
| DE | KDE Plasma |
| WM | Hyprland |
| Terminal | Kitty |
| App Launcher | Rofi |
| Panel | Waybar |
| Wallpaper | swww + Waypaper |
| Notification Daemon | Swaync |
| Font | JetBrains Mono Nerd Font |

---

## Keyring Setup

To keep browser logins and credentials persistent across both KDE and Hyprland sessions, both KWallet and GNOME Keyring are used together.

### Install

```bash
sudo pacman -S polkit-kde-agent gnome-keyring libsecret
```

### Hyprland config

Add these lines to your Hyprland config (`~/.config/hypr/hyprland.conf`):

```
exec-once = /usr/lib/polkit-kde-authentication-agent-1
exec-once = gnome-keyring-daemon --start --components=secrets,pkcs11,ssh
```

---

## HDD Auto Mount

To auto mount an NTFS partition on boot, add this to `/etc/fstab`:

```
UUID=YOUR-UUID /mnt/hdd ntfs-3g defaults,nofail,uid=1000,gid=1000 0 0
```

Then run:

```bash
sudo systemctl daemon-reload
sudo mount -a
```

---

## Structure

```
dotfiles/
├── hypr/        # Hyprland config
├── kitty/       # Kitty terminal config
├── waybar/      # Waybar config
├── rofi/        # Rofi config
└── swaync/      # Swaync notification config
```

---

## Font

Install JetBrains Mono Nerd Font:

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```
