# h-e-l-l-o-w-o-r-l-d

An unnecessary-ily long build pipeline for a hello world program

# Build

Only dependency you need is `docker-compose`<br/>
Run `./build.sh` to build the entire pipeline

## Clean

Run `./build.sh clean` to clean all build related files

## Run

Run `./build.sh run` to run the `hello_world` executable created by `./build.sh`

## Shell (for debugging)

Run `./build.sh shell` to start a shell in the container where `./build.sh` is run

# Contributing

1) Make sure to add necessary commands to `src/build.py` (or `src/start-build.sh`)
2) Add any intermediate files to `.gitignore` and `src/clean.sh`
3) Keep documentation up to date (mainly this README.md)

# Setup

## Tools

<!-- Add an entry here for every sub project -->
- `build_tools`: Zig library that gets compiled into a python module; used in `src/build.py` to execute bash statements
- `PATH`: C executable that transpiles [PATH](https://esolangs.org/wiki/PATH) to C
- `hello_world.c_maker`: PATH file that, when transpiled to c and compiled, will make the final `hello_world.c`

## Pipeline

<!-- Add an entry here for every step in the build process -->
- Build `tools` python module
  - `src/build_tools`
  - See `start-build.sh`

- Compile PATH to C transpiler
  - `src/PATH`
  - See `build.py`, `src/PATH/Makefile`

- Compile `hello_world.c_maker`
  - `src/hello_world.c_maker`
  - `hello_world.c_maker.PATH` -> `hello_world.c_maker.c` -> `hello_world.c_maker`
  - Uses PATH to C transpiler
  - See `build.py`, `src/hello_world.c_maker/build.sh`

- Compile `hello_world`
  - `hello_world.c_maker` -> `hello_world.c` -> `hello_world`
  - See `build.py`
