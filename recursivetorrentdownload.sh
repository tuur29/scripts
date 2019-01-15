#!/bin/bash

# This script scans all subfolders for torrent files
# then starts downloading them in the same folder as the torrent file


convertToUnix() {
    echo -e -n $1 | sed -e 's/\\/\//g' -e 's/://' | tr -d "\n"
}

convertToWindows() {
    echo -e -n $1 | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/' | tr -d "\n"
}

find "$(pwd)/" -type f -name "*.torrent" -print0 | while IFS= read -r -d $'\0' torrent; do 
    path="$(dirname "$torrent")/"
    name="$(basename "$torrent")"
    
    echo "Adding torrent $name"

    # Change this line according to your bittorrent client
    "C:\Program Files\qBittorrent\qbittorrent.exe" --save-path=\"$(convertToWindows "$path")\" "$(convertToWindows "$torrent")" &
    # "C:\Program Files (x86)\Deluge\deluge-console.exe" "add -p '$(convertToWindows "$path")' '$(convertToWindows "$torrent")'" &
done
