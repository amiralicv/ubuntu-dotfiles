#!/usr/bin/env bash
# Omarchy gruvbox look for GNOME (captured from my machine)
set -e
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-olive'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-olive-dark'
gsettings set org.gnome.desktop.interface accent-color 'slate'
gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font Propo 10'
gsettings set org.gnome.desktop.interface document-font-name 'JetBrainsMono Nerd Font Propo 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'JetBrainsMono Nerd Font Propo Bold 10'

# Ptyxis: gruvbox palette, block cursor
P=$(gsettings get org.gnome.Ptyxis default-profile-uuid | tr -d "'")
gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$P/ palette 'Gruvbox Material'
gsettings set org.gnome.Ptyxis cursor-shape block
gsettings set org.gnome.Ptyxis cursor-blink-mode off

# Wallpaper: Omarchy gruvbox backgrounds (downloaded, not stored in the repo)
W=~/Pictures/Wallpapers/omarchy-gruvbox; mkdir -p "$W"
B=https://raw.githubusercontent.com/omacom/omarchy/quattro/themes/gruvbox/backgrounds
for f in 1-the-backwater.jpg 3-village-square.jpg 4-idyllic-procession.jpg 5-leaves.jpg; do
  [ -f "$W/$f" ] || curl -sfL -o "$W/$f" "$B/$f" || echo "could not download $f"
done
U="file://$HOME/Pictures/Wallpapers/omarchy-gruvbox/1-the-backwater.jpg"
gsettings set org.gnome.desktop.background picture-uri "$U"
gsettings set org.gnome.desktop.background picture-uri-dark "$U"
gsettings set org.gnome.desktop.screensaver picture-uri "$U"
