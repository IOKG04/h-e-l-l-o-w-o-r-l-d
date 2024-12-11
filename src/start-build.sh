#!/usr/bin/bash

cd /code/
bash clean.sh

# "tools" python module
pip install --break-system-packages --root-user-action ignore -e build_tools

python build.py
