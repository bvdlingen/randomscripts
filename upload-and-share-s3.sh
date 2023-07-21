#!/bin/bash -e

# Set the magical DNS name for sharing
share_dns="share.vdl.io"

# Usage info - This script is your loyal sidekick to process and share files like a pro!
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-d date] [FILE]...
Do awesome stuff with FILE and behold the magic! With no FILE
or when FILE is -, prepare to be amazed by standard input.

    -h          show this incredible help and exit
    -d date     choose a date other than today's date
    -v          activate verbose mode. Use it multiple times for increasing awesomeness.
EOF
}

# Initialize our own variables:
verbose=0
date=$(date +%Y-%m-%d)

OPTIND=1
while getopts "hvd:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        v)  verbose=$((verbose+1))
            ;;
        d)  date=$(date -d "$OPTARG" +%Y-%m-%d)
            ;;
        '?')
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"

tmp=$(mktemp -u)
mkdir -p "$tmp/$date"
trap 'rm -rf "$tmp"' EXIT

for src in "$@"; do
    if ! test -f "$src"; then
        echo "Missing file '$src' - Abandoning mission!" >&2
        continue
    fi

    chmod +r "$src"

    file_extension="${src##*.}"

    if [ "$file_extension" == "png" ]; then
        echo "Converting $src to a magical PNG masterpiece..."
        pngquant --ext .png -f "$src"
    elif [ "$file_extension" == "jpg" ]; then
        if hash jpegoptim 2>/dev/null; then
            echo "Optimizing the enchanting JPG: $src"
            jpegoptim "$src"
        else
            echo "Jpegoptim not found - No further JPG enchantments."
        fi
    else
        echo "Unknown sorcery: $src - Skipping this file."
    fi

    dst=$(basename "$src")

    echo "Whisking away $src to the mystical realm of $tmp/$date/$dst..."
    cp -v "$src" "$tmp/$date/$dst"

    if aws s3 cp --storage-class STANDARD_IA --acl public-read "$tmp/$date/$dst" "s3://$share_dns/$date/"; then
        echo "File successfully transported to: https://$share_dns/$date/$dst - Magical!"
        if hash pbcopy 2>/dev/null; then
            echo "Sharing the link with your clipboard magic spell..."
            echo "https://$share_dns/$date/$dst" | pbcopy
        elif hash xclip 2>/dev/null; then
            echo "Enchanting the link into your clipboard using xclip magic..."
            echo "https://$share_dns/$date/$dst" | xclip -selection "clipboard" -i
        else
            echo "No pbcopy or xclip spells found - You'll have to manually share the link."
        fi
    else
        echo "Failed to send $src into the cloud - The magic portal seems blocked!"
    fi
done
