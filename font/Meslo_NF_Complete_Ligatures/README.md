### Quick install on MacOS using curl:
```bash
file_name="LigaMesloNerdFontMono.tar.xz" \
    && base_name="$(echo $file_name | cut -d '.' -f1)" \
    && mkdir -p "$HOME/Downloads/$base_name" \
    && curl -fsL -o- https://github.com/RayJameson/dotfiles/raw/main/font/Meslo_NF_Complete_Ligatures/"$file_name" \
    | tar -xJf - -C "$HOME/Downloads/$base_name" \
    && open -b com.apple.FontBook "$HOME/Downloads/$base_name/"*.ttf \
    && :
```

<img width="1023" alt="image" src="https://github.com/RayJameson/dotfiles/assets/67468725/399a9a56-5d5a-48ed-9c2a-a625ab4f39f4">
<img width="1023" alt="image" src="https://github.com/RayJameson/dotfiles/assets/67468725/ab74de2c-98f2-4131-a5f5-52349b970dc6">
