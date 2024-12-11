# h-e-l-l-o-w-o-r-l-d

<!--

TODO(zxcv): Add docker details here

-->

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

1) Building [`PATH`](PATH/), a [PATH](https://esolangs.org/wiki/PATH) to c transpiler
2) Transpiling [`hello_world.c_maker.PATH`](hello_world.c_maker/hello_world.c_maker.PATH) to c
3) Executing [`hello_world.c_maker`](hello_world.c_maker/), writing its `stdout` to `hello_world.c`
4) Compiling and linking `hello_world.c`

### Requirements

To build this, the following programs (and version) are required:
- `python3`
- `make`
- `gcc` supporting *ansi-c* and *c99*
- `sh` (should be replaced at some point)

## Markdown

This uses github-flavored markdown, so to insert a line break
put two spaces at the end of a line.
