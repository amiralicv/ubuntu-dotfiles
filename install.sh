#!/usr/bin/env bash
# Set up Ubuntu 26.04 from this repo: packages, configs (symlinked), GNOME look.
# Run `proxy_on` first if GitHub is slow or blocked.
#   ./install.sh            everything
#   ./install.sh --links    only link the configs
set -euo pipefail
DOT="$(cd "$(dirname "$0")" && pwd)"

link() { # link <repo path> <target>; backs up a real file that's in the way
  local src="$DOT/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then mv "$dst" "$dst.bak-$(date +%F)"; fi
  ln -sfn "$src" "$dst"
  echo "  $dst -> $1"
}

install_packages() {
  echo "==> apt packages"
  sudo apt update
  sudo apt install -y \
    ghostty tmux neovim starship zoxide eza bat fd-find ripgrep fzf \
    lazygit git-delta tealdeer btop fastfetch fonts-jetbrains-mono \
    build-essential unzip wl-clipboard clangd clang-format cmake ninja-build lldb
  mkdir -p ~/.local/bin
  ln -sf /usr/bin/batcat ~/.local/bin/bat
  ln -sf /usr/bin/fdfind ~/.local/bin/fd

  echo "==> JetBrainsMono Nerd Font"
  if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    tmp=$(mktemp -d)
    curl -fL --retry 3 -o "$tmp/font.tar.xz" \
      https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
    tar -xJf "$tmp/font.tar.xz" -C ~/.local/share/fonts/JetBrainsMonoNerd
    rm -rf "$tmp"; fc-cache -f >/dev/null
  fi

  echo "==> Python tools (uv) and Rust (rustup)"
  if command -v uv &>/dev/null; then
    for t in ruff basedpyright ty; do uv tool install "$t" || true; done
  else
    echo "  uv not found, skipping ruff/basedpyright/ty"
  fi
  if [ ! -x ~/.cargo/bin/rustup ]; then
    curl -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile minimal \
      -c rust-analyzer,clippy,rustfmt
  fi

  echo "==> VS Code extensions"
  if command -v code &>/dev/null; then
    while read -r e; do code --install-extension "$e" >/dev/null && echo "  $e"; done < "$DOT/vscode/extensions.txt"
  fi

  echo "==> Ghostty as default terminal"
  echo "com.mitchellh.ghostty.desktop" > ~/.config/xdg-terminals.list
  echo "com.mitchellh.ghostty.desktop" > ~/.config/ubuntu-xdg-terminals.list
}

link_configs() {
  echo "==> Linking configs"
  for f in rc shell aliases functions init; do link "bash/$f" ~/.config/bash/$f; done
  link inputrc ~/.inputrc
  link starship.toml ~/.config/starship.toml
  link ghostty/config ~/.config/ghostty/config
  link tmux/tmux.conf ~/.config/tmux/tmux.conf
  link btop/btop.conf ~/.config/btop/btop.conf
  link nvim ~/.config/nvim
  for f in settings.json keymap.json snippets themes; do link "zed/$f" ~/.config/zed/$f; done
  link vscode/settings.json ~/.config/Code/User/settings.json
  link vscode/keybindings.json ~/.config/Code/User/keybindings.json
  link zed/snippets ~/.config/Code/User/snippets
  link applications/com.mitchellh.ghostty.desktop ~/.local/share/applications/com.mitchellh.ghostty.desktop
  link applications/com.mitchellh.ghostty.service ~/.local/share/dbus-1/services/com.mitchellh.ghostty.service

  grep -q 'config/bash/rc' ~/.bashrc || echo '. ~/.config/bash/rc' >> ~/.bashrc
}

if [ "${1:-}" != "--links" ]; then install_packages; fi
link_configs
if [ "${1:-}" != "--links" ]; then echo "==> GNOME look"; "$DOT/gnome/apply.sh"; fi

echo
echo "Done. Log out and back in so GNOME, fonts and Ghostty pick everything up."
