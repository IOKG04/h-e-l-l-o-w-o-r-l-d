#! /bin/bash

# THIS FILE EXISTS FOR GITHUB ACTIONS

out="results.md"
rm -f "$out"
touch "$out"

# build
echo "Running build.sh"
build_out=$(script -q -c "./build.sh NO_LOG" /dev/null |\
    sed -E 's/\x1b\[([?;0-9]+)?[a-zA-Z]//g' |\
    sed -E 's/.\x08//g')

# print data to out
echo "Writing to $out"
echo "# Times"                  >> "$out"
echo '```'                      >> "$out"
echo "$build_out" | tail -n 3   >> "$out"
echo '```'                      >> "$out"
echo "# Output"                 >> "$out"
echo '```'                      >> "$out"
echo "$build_out"               >> "$out"
echo '```'                      >> "$out"
