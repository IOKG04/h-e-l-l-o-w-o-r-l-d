# Note about consistent build times with deno
The deno.json dependencies shouldnt have a significant effect on build time since the Dockerfile does `deno install`

# Outside dependencies (ensure these are up to date with the script and the Dockerfile)
- jsr:@std/jsonc@^1.0.1

# Permissions needed to run generate.js
- allow-read (steps.jsonc, template.py)
- allow-write (build.py)
