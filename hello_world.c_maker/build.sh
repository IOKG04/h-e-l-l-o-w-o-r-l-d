#! /bin/sh

if [ "$1" = "clean" ]; then
    echo "cleaning"
    rm -f hello_world.c_maker.c
    rm -f hello_world.c_maker
else
    echo "transpiling hello_world.c_maker.PATH to c"
    ../PATH/PATH hello_world.c_maker.PATH hello_world.c_maker.c
    echo "compiling and linking hello_world.c_maker.c"
    gcc -o hello_world.c_maker hello_world.c_maker.c -std=c99 -O3
fi
