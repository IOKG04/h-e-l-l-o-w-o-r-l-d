#!/usr/bin/bash

clean() {
    CMD="rm -rf $@"
    echo $CMD
    $CMD
}

cd /code/generate_build_py/
clean deno.lock
cd -

cd /code/build_tools/
clean .zig-cache tools.* zig-out
cd -

cd /code/PATH
make clean
cd -

cd /code/hello_world.c_maker
clean hello_world.c_maker.c hello_world.c_maker
cd -

cd /code/
clean build.py
clean hello_world.c
clean hello_world
cd -
