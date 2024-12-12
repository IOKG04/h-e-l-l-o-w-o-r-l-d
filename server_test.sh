#! /bin/bash

# THIS FILE EXISTS FOR GITHUB ACTIONS
# no one will stop you from using it urself,
# but everything you can do with this,
# you will also get by just running the build.sh

# clear outp_md
outp_md="results.md"
echo "Clearing $outp_md"
if [ -e "$outp_md" ]; then
    rm "$outp_md"
fi
touch "$outp_md"

# build
echo "Running build.sh"
build_outp=$(script -q -c "./build.sh SILENTIO" /dev/null)

# print data to outp_md
echo "Writing to $outp_md"
echo "# Times"                 >> "$outp_md"
echo ""                        >> "$outp_md"
echo "$build_outp" | tail -n 3 >> "$outp_md"
echo ""                        >> "$outp_md"
echo "# Output"                >> "$outp_md"
echo ""                        >> "$outp_md"
echo "$build_outp"             >> "$outp_md"
