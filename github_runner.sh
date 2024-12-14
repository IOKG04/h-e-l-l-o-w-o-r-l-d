#! /bin/bash

# THIS FILE EXISTS FOR GITHUB ACTIONS

out="results.md"
rm -f "$out"
touch "$out"

# build
echo "Running build.sh"
build_outp=$(script -q -c "./build.sh NO_LOG" /dev/null)

# print data to out
echo "Writing to $out"
echo "# Times"                                          >> "$out"
echo '```'                                              >> "$out"
echo "$build_outp" | tail -n 3                          >> "$out"
echo '```'                                              >> "$out"
echo "# Output"                                         >> "$out"
echo '```'                                              >> "$out"
echo "$build_outp" | sed 's/\x1b\[[?;0-9][a-zA-Z]//g'   >> "$out"
echo '```'                                              >> "$out"
