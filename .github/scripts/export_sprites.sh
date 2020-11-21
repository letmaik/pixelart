#!/bin/bash
set -e

ASEPRITE="xvfb-run -e /dev/stdout -a ./aseprite-dist/bin/aseprite"

rm -rf exported
mkdir -p exported/img

md="<p align=\"center\">\n\n"

paths=(sprites/*.aseprite)
# iterate in reverse
for ((i=${#paths[@]}-1; i>=0; i--)); do
    path=${paths[$i]}
    echo "$path"

    filename="${path##*/}"
    ext="${filename##*.}"
    file="${filename%.*}"
    
    $ASEPRITE --batch $path \
        --scale 4 \
        --sheet "exported/img/${file}.png" \
        --sheet-type horizontal
    
    url="https://github.com/letmaik/pixelart/blob/master/$path"
    md+="| [![$file](img/${file}.png)]($url) |\n"
    md+="|:--:|\n"
    md+="| [$file]($url) |\n\n"
done

md+="</p>"

printf "$md" > "exported/README.md"
