#!/usr/bin/bash

cd /code/
echo h-e-l-l-o-w-o-r-l-d build starting

# build "tools" python module
pip install --break-system-packages --root-user-action ignore -e build_tools

# run main build script
python build.py
