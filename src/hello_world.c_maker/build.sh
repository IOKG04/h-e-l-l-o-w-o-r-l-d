#! /bin/sh

echo "transpiling hello_world.c_maker.PATH to c"
../PATH/PATH hello_world.c_maker.PATH hello_world.c_maker.c
echo "compiling and linking hello_world.c_maker.c"
gcc -o hello_world.c_maker hello_world.c_maker.c -std=c99 -O3
