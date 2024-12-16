#! /bin/sh

if [ "$1" = "help" ]; then
    echo "$0        | Build bf2path"
    echo "$0 clean  | Clean bf2path"
    echo "$0 help   | Show help message"
elif [ "$1" = "clean" ]; then
    echo "Cleaning bf2path"
    rm -f bf2path
else
    echo "Building bf2path"
    nim -o:bf2path compile --opt:size main.nim
fi
