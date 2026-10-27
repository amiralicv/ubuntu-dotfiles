# ubuntu-dotfiles

My Ubuntu 26.04 (GNOME) setup: a fast terminal and Omarchy's gruvbox look across the desktop, terminal and editors.

## What's inside

| Folder / file | What it is |
|---|---|
| `bash/` | Omarchy-style modular bash config: history, aliases (`ls`→eza, `cd`→zoxide, `lg`, `t`, `n`…), functions, tool init |
| `inputrc` | Readline: case-insensitive completion, Tab cycles matches, ↑/↓ search history by prefix |
| `starship.toml` | Omarchy's minimal prompt with a `➜` symbol |
| `ghostty/config` | Ghostty: JetBrainsMono Nerd Font, block cursor, compact titlebar, gruvbox colours |
| `applications/` | Overrides Ubuntu's Ghostty launcher, whose `--shell-integration-features` flag breaks the block cursor |
| `tmux/tmux.conf` | Ctrl+Space prefix, status bar on top, Alt+arrows between panes, gruvbox colours |
| `btop/btop.conf` | Gruvbox Material theme, vim keys |
| `nvim/` | LazyVim with gruvbox and a block cursor in every mode |
| `zed/` | Zed: JetBrains keymap, Omazed (gruvbox) themes, snippets, Python/C/C++/Rust language servers |
| `vscode/` | VS Code set up the same way as Zed, plus `extensions.txt` |
| `gnome/apply.sh` | GNOME look: dark Yaru-olive, fonts, Ptyxis palette, Omarchy wallpaper |
| `gnome/revert.sh` | Back to the stock Ubuntu look |
| `scripts/dev-services.sh` | Docker + local PostgreSQL |

## Install

```sh
git clone <this repo> ~/projects/ubuntu-dotfiles
cd ~/projects/ubuntu-dotfiles
./install.sh            # packages, tools, configs, GNOME look
./install.sh --links    # only link the configs
./scripts/dev-services.sh   # optional: Docker + Postgres
```

Configs are **symlinked** into place, so editing `~/.config/...` edits this repo. Any real file in the way is kept as `<name>.bak-<date>`.

## Notes

- Some settings contain machine-specific paths (`/home/amirali/...`) and a local proxy (`127.0.0.1:10809`) in Zed, VS Code and Docker. Change them on another machine.
- Wallpapers aren't stored here; `gnome/apply.sh` downloads them from the Omarchy repo.
