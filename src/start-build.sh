#!/usr/bin/bash

cd /code/

# build "tools" python module
pip install --break-system-packages --root-user-action ignore -e build_tools

# run main build script
python build.py
