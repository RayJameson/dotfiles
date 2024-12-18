# This is modified version of [Iosevka](https://typeof.net/Iosevka/) font

## What are modifications in the customizer

- Font inherits `Menlo` style
- All ligatures available in Iosevka customizer are turned on
- Spacing: Normal
- Dot-zero (enabled harfbuzz features change it to slashed zero)
- All ligatures with `=` or `-` without notches

(_you can check other modifications by importing [private-build-plans.toml](./private-build-plans.toml) into Iosevka customizer_)

[How to build custom font](https://github.com/be5invis/Iosevka/blob/main/doc/custom-build.md)

### **TLDR:**

```bash
git clone --depth 1 https://github.com/be5invis/Iosevka.git
```

copy [private-build-plans.toml](./private-build-plans.toml) to cloned repo dir

```bash
# only `ttf` without hinting, but there are other options, check link above
npm run build -- ttf-unhinted::Iosevka --jCmd=8
```

## Further modifications with [Ligaturizer](https://github.com/ToxicFrog/Ligaturizer)

Not all ligatures included in the font, for example `&&`, so I decided to ligaturize modified font

```bash
git clone --filter=blob:none --depth 1 git@github.com:ryanoasis/nerd-fonts \
    && cd nerd-fonts \
    && git clone --filter=blob:none --depth 1 https://github.com/ToxicFrog/Ligaturizer.git \
    && cd Ligaturizer
```

Now we should use built fonts to ligaturize them,  
I use changed script because by default family name gets repeated in font name,
Also I disabled some ligatures I don't like.

Replace files in `nerd-fonts` dir to replicate my settings:

```bash
cp *.py ~/nerd-fonts/Ligaturizer
```

```bash
# make sure you put your Iosevka dir path in `fd` command
fd . ~/Iosevka/dist/Iosevka/TTF -t f -e ttf -x \
    fontforge -script ligaturize.py --prefix "" --output-name {/.} --output-dir ./fonts/output {}
```

After this we should include patch by nerd-font

```bash
cd .. # back to `nerd-fonts` dir
fd -t file -e ttf -Ii iosevka Ligaturizer/fonts/output -x fontforge -script font-patcher -sc
```

Now we should have `ttf` files in the same dir, on MacOS we can install them like this:

```bash
open ./*.ttf
```
