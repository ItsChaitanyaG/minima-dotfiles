#!/usr/bin/env bash

# ===================================================================
# Minima Dotfiles Setup Script
# Installs supporting tools, applies configs, sets theme & keyring
# ===================================================================

set -e

REPO_URL="https://github.com/ItsChaitanyaG/minima-dotfiles.git"
CLONE_DIR="$HOME/minima-dotfiles"
CONFIG_DIR="$HOME/.config"

echo "=================================================="
echo " Minima Dotfiles Setup"
echo "=================================================="

# -------------------------------------------------------------
# 1. Install yay if not present
# -------------------------------------------------------------
if ! command -v yay &>/dev/null; then
    echo "[1/8] Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg -si --noconfirm
    cd "$HOME"
    rm -rf /tmp/yay-bin
else
    echo "[1/8] yay already installed, skipping."
fi

# -------------------------------------------------------------
# 2. Install supporting packages
# -------------------------------------------------------------
echo "[2/8] Installing supporting packages..."

PACMAN_PKGS=(
    kitty
    fuzzel
    dunst
    waybar
    polkit-kde-agent
    gnome-keyring
    libsecret
    qt6ct
    qt5ct
    nwg-look
    ttf-jetbrains-mono-nerd
    ntfs-3g
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    zsh
    greetd
    greetd-tuigreet
    nemo
    mpv
    loupe
    mission-center
    network-manager-applet
    grim
    slurp
    wl-clipboard
    brightnessctl
    playerctl
    pipewire
    pipewire-pulse
    wireplumber
)

sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

AUR_PKGS=(
    swww
    waypaper
    bibata-cursor-theme-bin
)

yay -S --needed --noconfirm "${AUR_PKGS[@]}"

# Nordic-darker icon theme: no reliable AUR package installs this to the
# correct icon path. If you have it backed up, copy it into place manually:
#   cp -r /path/to/Nordic-darker ~/.local/share/icons/
# Otherwise grab it from gnome-look.org / the Nordic-Zafiro icon pack and
# extract into ~/.local/share/icons/Nordic-darker

# -------------------------------------------------------------
# 3. Clone dotfiles repo
# -------------------------------------------------------------
echo "[3/8] Cloning dotfiles repo..."

if [ -d "$CLONE_DIR" ]; then
    echo "Repo already exists locally, pulling latest..."
    cd "$CLONE_DIR"
    git pull
    cd "$HOME"
else
    git clone "$REPO_URL" "$CLONE_DIR"
fi

# -------------------------------------------------------------
# 4. Copy configs (skip rofi and swaync as requested)
# -------------------------------------------------------------
echo "[4/8] Applying configs..."

mkdir -p "$CONFIG_DIR"

FOLDERS_TO_COPY=(
    hypr
    niri
    kitty
    waybar
    fuzzel
    dunst
)

for folder in "${FOLDERS_TO_COPY[@]}"; do
    if [ -d "$CLONE_DIR/$folder" ]; then
        echo "  -> Copying $folder"
        cp -rf "$CLONE_DIR/$folder" "$CONFIG_DIR/"
    else
        echo "  -> Skipping $folder (not found in repo)"
    fi
done

echo "  -> Skipping rofi/ and swaync/ (not used in current setup)"

# -------------------------------------------------------------
# 5. Apply Graphite GTK theme + Bibata cursor theme
# -------------------------------------------------------------
echo "[5/8] Applying Graphite theme and cursor..."

if [ ! -d "$HOME/.themes/Graphite-Dark" ] && [ ! -d "/usr/share/themes/Graphite-Dark" ]; then
    git clone https://github.com/vinceliuice/Graphite-gtk-theme.git /tmp/graphite-theme
    cd /tmp/graphite-theme
    ./install.sh -c dark -s compact --tweaks rimless
    cd "$HOME"
    rm -rf /tmp/graphite-theme
else
    echo "Graphite theme already installed, skipping."
fi

mkdir -p "$CONFIG_DIR/gtk-3.0" "$CONFIG_DIR/gtk-4.0"

cat > "$CONFIG_DIR/gtk-3.0/settings.ini" << EOF
[Settings]
gtk-theme-name=Graphite-Dark
gtk-icon-theme-name=Nordic-darker
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

cp "$CONFIG_DIR/gtk-3.0/settings.ini" "$CONFIG_DIR/gtk-4.0/settings.ini"

mkdir -p "$HOME/.icons/default"
cat > "$HOME/.icons/default/index.theme" << EOF
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=Bibata-Modern-Classic
EOF

# -------------------------------------------------------------
# 6. Set up environment variables for keyring + cursor + Qt
# -------------------------------------------------------------
echo "[6/8] Setting up environment variables..."

PROFILE_FILE="$HOME/.zprofile"
[ -f "$HOME/.bash_profile" ] && PROFILE_FILE="$HOME/.bash_profile"

{
    echo ""
    echo "# Minima dotfiles environment setup"
    echo "export XCURSOR_THEME=Bibata-Modern-Classic"
    echo "export XCURSOR_SIZE=24"
    echo "export QT_QPA_PLATFORMTHEME=qt6ct"
} >> "$PROFILE_FILE"

# -------------------------------------------------------------
# 7. Set default shell to zsh
# -------------------------------------------------------------
echo "[7/8] Setting default shell to zsh..."

if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)" "$USER"
    echo "  -> Shell changed to zsh (takes effect on next login)"
else
    echo "  -> zsh is already the default shell"
fi

# -------------------------------------------------------------
# 8. Set up greetd with tuigreet
# -------------------------------------------------------------
echo "[8/8] Setting up greetd..."

sudo mkdir -p /etc/greetd

if [ ! -f /etc/greetd/config.toml ]; then
    sudo tee /etc/greetd/config.toml > /dev/null << EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --user-menu --cmd Hyprland"
user = "greeter"
EOF
    echo "  -> greetd config created (launches Hyprland via tuigreet user-menu)"
else
    echo "  -> /etc/greetd/config.toml already exists, skipping (edit manually if needed)"
fi

# Disable other display managers if active, enable greetd
for dm in gdm sddm lightdm; do
    if systemctl is-enabled "$dm" &>/dev/null; then
        sudo systemctl disable "$dm"
        echo "  -> Disabled $dm"
    fi
done

sudo systemctl enable greetd

echo "=================================================="
echo " Setup complete!"
echo " - Configs applied: hypr, niri, kitty, waybar, fuzzel, dunst"
echo " - Theme: Graphite-Dark + Bibata cursor"
echo " - Keyring lines are already in your hypr config (exec-once)"
echo " - Shell set to zsh"
echo " - greetd enabled as display manager (launches Hyprland by default)"
echo " - Reboot for all changes to take effect"
echo "=================================================="
