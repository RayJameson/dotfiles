# OS X config

<img width="1728" alt="image" src="https://github.com/RayJameson/dotfiles/assets/67468725/6b597549-47a6-4e94-854f-7bc01102c2b0">
<img width="1728" alt="image" src="https://github.com/RayJameson/dotfiles/assets/67468725/f8b354e4-b8f1-475d-929b-2ae001d300f5">

### To install config:

```bash
git clone --depth 1 --recurse-submodules git@github.com:RayJameson/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
p10k configure
```

## To update all submodules:

```bash
git pull --recurse-submodules
```

## List of utilities I use

### CLI and TUI apps:

- [zsh](https://zsh.sourceforge.io/) - shell that I use
- [tmux](https://github.com/tmux/tmux) - terminal multiplexer
- [sesh](https://github.com/joshmedeski/sesh) - TMUX session manager (successor of [t-smart-tmux-session-manager](https://github.com/joshmedeski/t-smart-tmux-session-manager))
- [brew](https://brew.sh/) - package manager
- [nvim](https://github.com/neovim/neovim) - the only true vim
- [zoxide](https://github.com/ajeetdsouza/zoxide) - `cd` replacement
- [eza](https://github.com/eza-community/eza) - `ls` and `tree` replacement, successor of `exa
- [bat](https://github.com/sharkdp/bat) - `cat` replacement
- [ripgrep](https://github.com/BurntSushi/ripgrep) - `grep` replacement
- [fd](https://github.com/sharkdp/fd) - `find` replacement
- [ncdu](https://code.blicky.net/yorhel/ncdu/) - `du` replacement
- [fzf](https://github.com/junegunn/fzf) - fuzzy finder
- [tealdeer](https://github.com/dbrgn/tealdeer) - faster tldr written in certain crab language
- [lazygit](https://github.com/jesseduffield/lazygit) - git TUI without nonsense
- [lazydocker](https://github.com/jesseduffield/lazydocker) - docker TUI
- [ranger](https://github.com/ranger/ranger) - TUI file manager with vim motions
- [btop](https://github.com/aristocratos/btop) - htop alternative with additional panes
- [lnav](https://github.com/tstack/lnav) - Log file navigator
- [gh](https://github.com/cli/cli) - GitHub CLI
- [ptpython](https://github.com/prompt-toolkit/ptpython) - better python REPL with syntax highlighting and auto-completion (IPython supported)
- [pyenv](https://github.com/pyenv/pyenv) - python version manager
- [nvm](https://github.com/nvm-sh/nvm) - node version manager
- [glow](https://github.com/charmbracelet/glow) - render markdown in terminal

### Preconfigs

- [astronvim](https://github.com/AstroNvim/AstroNvim) - neovim config maintained by cool guys
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) - framework for ZSH config and plugins

### GUI apps

- [keepassxc](https://github.com/keepassxreboot/keepassxc) - Cross platform open-source keepass port
- ~~[maccy](https://github.com/p0deje/Maccy) - Lightweight clipboard manager for MacOS (can't believe it's still not native feature)~~  
    raycast has same functionality by default
- [amethyst](https://github.com/ianyh/Amethyst) - tiling window manager for MacOS, inspired by xmonad
- [wezterm](https://github.com/wez/wezterm) - terminal emulator with config in Lua (I <3 Lua)
- [raycast](https://www.raycast.com/) - Spotlight replacement (closed source)
- ~~[arc](https://arc.net/) - very cool browser with conceivable toolbar,literally just a border around and nothing else (closed source)~~
- [zen] - I'm using this browser now
- [obsidian](https://obsidian.md/) - personal wiki (closed source)

## Brew stuff that need to be installed on a fresh system

```bash
# cli apps
brew install ripgrep fd ncdu bat eza bat btop ranger lnav gh \
    glow nvm pyenv tealdeer fzf fzy zoxide tmux pipx zsh bash \
    ncurses coreutils gsed gnu-which gnu-tar git trash \
    wget curl tree-sitter sqlite rich openssh openssl \
    luarocks lua luajit clang jq lazydocker gpg-tui asciinema stylua \
    man-db parallel && \
# some nightly stuff
brew install --fetch-HEAD lazygit && \
# gui apps
brew install --cask wezterm \
    raycast obsidian keepassxc docker \
    keycastr zen-browser && \
# tiling manager inspired by i3wm
brew install --cask nikitabobko/tap/aerospace
```

## Rust
```bash
# rust lang and toolchain should be installed via rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
```bash
# rust applications
cargo install bob-nvim
```

# Archlinux config
Nice guide
https://ventureo.codeberg.page/v2024.07.21/

## Initial setup
```bash
sudo pacman -S --needed git \
    base-devel yay archlinux-keyring \
    archcraft-i3wm autotiling dex
```
- uncomment the `[multilib]` and `[extra]` sections in /etc/pacman.conf
- enable the firewall (profile in gufw dir)
### Apps
## CLI
```bash
yay -Syu --needed lazygit tmux sesh-bin zoxide \
    eza bat fd ncdu fzf tealdeer \
    btop ptpython python-pipx \
    bob stderred-git syncthing \
    diff-so-fancy gpa-git \
    github-cli nodejs npm
```
## GUI
```bash
yay -Syu --needed keepassxc zen-browser-avx2-bin \
    wezterm steam copyq telegram-desktop \
    nordvpn-bin qbittorrent-enchanced \
    syncthingtray-qt6 \
    neovide todoist-nativefier vencord \
    betterbird-bin
```
## Wine/Proton stuff
```bash
yay -Syu --needed steamtinkerlaunch-git \
    wine winecfg winetricks
```

### Audio stuff (Pipewire)
```bash
yay -Syu --needed wireplumber pamixer \
    amixer pipewire-jack carla \
    pipewire-pulse pipewire-alsa \
    pipewire
```

### Graphics stuff (nVidia)
```bash
sudo pacman -S --needed nvidia-dkms \
    nvidia-utils \
    lib32-nvidia-utils \
    nvidia-settings \
    lib32-opencl-nvidia \
    opencl-nvidia \
    libxnvctrl \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader
```
