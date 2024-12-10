#! /bin/python
#  ^ for linux, idk if this works on windows

import os
import sys
import subprocess

# removes file (without erroring on non existence i hope)
def r_f(file):
    if os.path.exists(file):
        os.remove(file)

# builds everything
def build():
    print("Building PATH")
    subprocess.run(["make"], cwd="PATH/")
    print("Building hello_world.c_maker")
    subprocess.run(["./build.sh"], cwd="hello_world.c_maker/")
    print("Executing hello_world.c_maker and writing to a file")
    with open("hello_world.c", "w") as f:
        subprocess.run(["./hello_world.c_maker"], cwd="hello_world.c_maker/", stdout=f)
    print("Compiling and linking hello_world.c")
    subprocess.run(["gcc", "-o", "hello_world", "hello_world.c", "-Wall", "-Wextra", "-Werror", "-O3"])

# cleans everything
def clean():
    print("Cleaning PATH")
    subprocess.run(["make", "clean"], cwd="PATH/")
    print("Cleaning hello_world.c_maker")
    subprocess.run(["./build.sh", "clean"], cwd="hello_world.c_maker/")
    print("Cleaning hello_world.c and hello_world")
    r_f("hello_world.c")
    r_f("hello_world")

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1].lower() == "clean":
        clean()
    else:
        build()
