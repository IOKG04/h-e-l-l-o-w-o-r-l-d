# h-e-l-l-o-w-o-r-l-d

# Setup
Uses docker to build a container that can build this perfectly normal project

# Build
Dependencies:
  - docker-compose

`./build.sh`

## Clean
./clean.sh

## Contributing
1) Make sure to add necessary commands to `src/build.py` (or `src/start-build.sh`)
2) Add any intermediate files to `.gitignore` and `clean.sh`

# Pipeline
- Compile a zig library into a python module
- Building [`PATH`](PATH/), a [PATH](https://esolangs.org/wiki/PATH) to c transpiler
- Transpiling [`hello_world.c_maker.PATH`](hello_world.c_maker/hello_world.c_maker.PATH) to c
- Executing [`hello_world.c_maker`](hello_world.c_maker/), writing its `stdout` to `hello_world.c`
- Compiling and linking `hello_world.c` with gcc

<!--

I will write more here some day, but for the time being, here is the tldr:
- `h-e-l-l-o-w-o-r-l-d` should, when built, output a single executable which prints `Hello World!` when run
- `h-e-l-l-o-w-o-r-l-d` should take as long as possible to build
- Time added to the build process by non-deterministic effects (like random number generation or installing files from the internet)
  is not counted towards the build time

## Current setup

The process of building is started by running [`build.py`](./build.py).
This is because python is probably the most universal scripting language nowadays, so it should be the entry point.

To clean, run `build.py clean`.

## The *pipeline*

The following is a description of exactly what happens during the build process.
If you add something to the build process, please write that down here.

## Markdown

This uses github-flavored markdown, so to insert a line break
put two spaces at the end of a line.

-->
