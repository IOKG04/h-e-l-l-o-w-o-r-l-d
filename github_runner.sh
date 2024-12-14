#! /bin/bash

# THIS FILE EXISTS FOR GITHUB ACTIONS

out="results.md"
rm -f "$out"
touch "$out"

# build container manually so the build output doesnt show up in $out
# because for some reason despite adding --quiet it still logs in GA :/
echo "Building container"
docker-compose build --quiet

# build
echo "Running build.sh"
build_cmd='DONT_BUILD_CONTAINER=1 QUIET_LOG=1 ./build.sh'
build_out=$(script -q -c "$build_cmd" /dev/null |\
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
