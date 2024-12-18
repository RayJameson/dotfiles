# MacOS and Archlinux configuration managed by [Chezmoi](https://chezmoi.io)

## Software I use
- [MacOS](../.chezmoidata/darwin-packages.toml)
- [Archlinux](../.chezmoidata/archlinux-packages.toml)

## To install config:

- Archlinux only (after installation):
  - uncomment the `[multilib]` and `[extra]` sections in `/etc/pacman.conf`
  - enable the firewall (profile in `.gufw` dir)

```shell
# MacOS:
brew install chezmoi
# Archlinux
pacman -S chezmoi

# Curl
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME"/.local/bin
# Wget
sh -c "$(wget -qO- get.chezmoi.io)" -- -b "$HOME"/.local/bin
```

- Install config

```shell
chezmoi init RayJameson
```
Now you will have my config in `~/.local/share/chezmoi`

### ⚠️ WARNING: Read until the end before you input any commands ⚠️
Be careful, if you write `chezmoi apply` my config will be applied to your home directory.
Chezmoi will warn you about overwriting files, otherwise you will end up with a bunch of my config  
files in your home directory

if you want just to poke around, best course is to apply my config on some tmp directory like this:
```shell
mkdir -p /tmp/chezmoi/rayjameson
chemzoi apply --exclude encrypted,scripts \
    --destination /tmp/chezmoi/rayjameson
```
It will copy config files to `/tmp/chezmoi/rayjameson`, but will not run any scripts  
from `.chezmoiscripts` directory and will not copy encrypted files (since you don't have private keys anyway).  

I also have to warn you some of my config depends on external repositories which also would be downloaded with this command.  
You can check them out `.chezmoiexternal.toml.tmpl` file, (it's mostly for `zsh` and `tmux`)
If you don't want to install externals you can run this command:
```shell
chemzoi apply --exclude encrypted,scripts,externals \
    --destination /tmp/chezmoi/rayjameson
```
