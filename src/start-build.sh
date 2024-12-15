#!/usr/bin/bash

cd /code/
echo h-e-l-l-o-w-o-r-l-d build starting

deno run --allow-read --allow-write /code/generate_build_py/generate.js /code/build.py /code/build_steps.jsonc /code/build_template.py

# build "tools" python module
pip install --break-system-packages --root-user-action ignore -e build_tools

# run main build script
python build.py
