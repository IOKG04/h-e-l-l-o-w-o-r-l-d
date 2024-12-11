#! /bin/sh

if [ -e "hello_world" ]; then
    echo "Running hello_world"
    echo ""
    ./hello_world
else
    echo "ERROR: hello_world does not exists, please build first"
fi
