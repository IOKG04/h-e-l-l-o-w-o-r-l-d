#! /bin/sh

echo "transpiling hello_world.c_maker.bf to PATH"
../bf2path/bf2path hello_world.c_maker.bf hello_world.c_maker.PATH
echo "transpiling hello_world.c_maker.PATH to c"
../PATH/PATH hello_world.c_maker.PATH hello_world.c_maker.c
echo "compiling and linking hello_world.c_maker.c"
gcc -o hello_world.c_maker hello_world.c_maker.c -std=c99 -O3
