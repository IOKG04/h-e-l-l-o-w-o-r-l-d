#!/usr/bin/bash

clean() {
    CMD="rm -rf $@"
    echo $CMD
    $CMD
}

cd /code/build_tools/
clean .zig-cache tools.* zig-out
cd -

make -C /code/PATH clean

cd /code/hello_world.c_maker
clean hello_world.c_maker.c hello_world.c_maker
cd -

cd /code/
clean hello_world.c
clean hello_world
cd -
