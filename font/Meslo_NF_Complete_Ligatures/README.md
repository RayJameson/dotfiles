### Quick install on MacOS using curl:
```bash
file_name="LigaMesloLG_NF.tar.xz" \
    && base_name="$(echo $file_name | cut -d '.' -f1)" \
    && mkdir -p "$HOME/Downloads/$base_name" \
    && curl -fsL -o- https://github.com/RayJameson/dotfiles/raw/main/font/Meslo_NF_Complete_Ligatures/"$file_name" \
    | tar -xJf - -C "$HOME/Downloads/$base_name" \
    && open -b com.apple.FontBook "$HOME/Downloads/$base_name/"*.ttf \
    && :
```

### How to patch font (info for me):
Prerequisites:
- [nerd-fonts source](https://github.com/ryanoasis/nerd-fonts)
- [ligaturizer](https://github.com/ToxicFrog/Ligaturizer)
- [fd](https://github.com/sharkdp/fd) (optional)
```bash
# nerd-fonts dir, ligaturizer is in the same dir
cp -r ./src/unpatched-fonts/Meslo Ligaturizer/fonts
cd Ligaturizer

fd -t file -e ttf . fonts/Meslo -x fontforge -script ligaturize.py --output-dir fonts/output
# or
find fonts/Meslo -type f -name "*.ttf" -exec fontforge -script ligaturize.py --output-dir fonts/output {} \;

cd ..

# for mono
fd -t file -e ttf -I . Ligaturizer/fonts/output -x fontforge -script font-patcher -sc
# for regular
fd -t file -e ttf -I . Ligaturizer/fonts/output -x fontforge -script font-patcher -c

# or

# for mono
find Ligaturizer/fonts/output -name "*.ttf" -exec fontforge -sccript font-patcher -sc {} \;
# for regular
find Ligaturizer/fonts/output -name "*.ttf" -exec fontforge -sccript font-patcher -c {} \;

open -b com.apple.FontBook ./Liga*.ttf

# create archive to upload to github
tar -caf LigaMesloLG_NF.tar.xz ./Liga*.ttf
```

<img width="1023" alt="image" src="https://github.com/RayJameson/dotfiles/assets/67468725/399a9a56-5d5a-48ed-9c2a-a625ab4f39f4">
<img width="1023" alt="image" src="https://github.com/RayJameson/dotfiles/assets/67468725/ab74de2c-98f2-4131-a5f5-52349b970dc6">
