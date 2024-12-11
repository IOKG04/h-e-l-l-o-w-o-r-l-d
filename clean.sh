#!/usr/bin/bash

clean() {
    echo rm -rf $@
    rm -rf $@
}

cd src/build_tools/
clean .zig-cache tools.* zig-out
cd -

make -C src/PATH clean

cd src/hello_world.c_maker
clean hello_world.c_maker.c hello_world.c_maker
cd -

cd src
clean hello_world.c
clean hello_world
cd -
