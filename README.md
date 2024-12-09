# h-e-l-l-o-w-o-r-l-d

I will write more here some day, but for the time being, here is the tldr:
- `h-e-l-l-o-w-o-r-l-d` should, when built, output a single executable which prints `Hello World!` when run
- `h-e-l-l-o-w-o-r-l-d` should take as long as possible to build
- Time added to the build process by non-deterministic effects (like random number generation or installing files from the internet)
  is not counted towards the build time

## Current setup

The process of building is started by running [`build.py`](./build.py).  
This is because python is probably the most universal scripting language nowadays, so it should be the entry point.
