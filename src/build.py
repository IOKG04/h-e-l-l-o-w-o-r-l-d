#! /bin/python

# Not meant to be imported, will throw error
if __name__ != "__main__":
    dont_import_this_script

# created by start-build.sh
import tools

tools.run("/code/", "make -C PATH")
tools.run("/code/hello_world.c_maker/", "./build.sh")
tools.run("/code/hello_world.c_maker/", "./hello_world.c_maker > /code/hello_world.c")
tools.run("/code/", "gcc -o hello_world hello_world.c -Wall -Wextra -Werror -O3")

tools.run("/code/", "./hello_world")
