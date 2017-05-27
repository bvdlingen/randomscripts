#!/bin/bash -e

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-d date] [FILE]...
Do stuff with FILE and write the result to standard output. With no FILE
or when FILE is -, read standard input.

    -h          display this help and exit
    -d date     date other than today's date
    -v          verbose mode. Can be used multiple times for increased
                verbosity.
EOF
}

# Initialize our own variables:
verbose=0
date=$(date +%Y-%m-%d)

OPTIND=1 # Reset is necessary if getopts was used previously in the script.  It is a good idea to make this local in a function.
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
shift "$((OPTIND-1))" # Shift off the options and optional --.

tmp=$(mktemp -u)
mkdir -p "$tmp/$date"
trap 'rm -rf "$tmp"' EXIT

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
