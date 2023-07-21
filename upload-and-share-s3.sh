#!/bin/bash -e

# Magic Image Sharer!

: << ~_~
Usage info: Discover the hidden powers of this mystical script.

- Use the -d flag to select your own date, bending time to your will.
- Unleash the -v flag to summon verbosity and reveal the script's actions.

Mysterious Image Transformation:
- PNG images undergo the quantization spell.
- JPEG images bask in the glory of jpegoptim!

Cloud Portals Unleashed:
- AWS deities securely transfer your images to share.vdl.io.

Bewitching Secrets:
- With pbcopy or xclip, copy the secret sharing link to your clipboard!

Gather your images, align the stars, and let this mystical script weave its wonders!
But beware, sorcerer, tweak the source wisely before summoning its magic!
~_~

tmp=$(mktemp -u)
mkdir -p "$tmp/$date"
trap 'rm -rf "$tmp"' EXIT

# The actual script starts here:

for src in "$@"
do
for src in "$@"
do
    if ! test -f "$src"
    then
        echo Missing filename "$src" >&2
        continue
    fi

    chmod +r "$src"

    if test "${src##*.}" == "png"
    then
        pngquant --ext .png -f "$src"
    fi

    if test "${src##*.}" == "jpg"
    then
        hash jpegoptim && jpegoptim "$src"
    fi

    dst=$(basename "$src")

    cp -v "$src" "$tmp/$date/$dst"

    if aws s3 cp --storage-class STANDARD_IA --acl public-read "$tmp/$date/$dst" "s3://share.vdl.io/$date/"
    then
        logger "https://share.vdl.io/$date/$dst"
        if hash pbcopy 2>/dev/null
        then
            echo "https://share.vdl.io/$date/$dst" | pbcopy
        else
            echo "https://share.vdl.io/$date/$dst" | xclip -selection "clipboard" -i
        fi
    fi

done
