#!/usr/bin/bash

cd /code/

pip install --break-system-packages --root-user-action ignore -e build_tools

python build.py
