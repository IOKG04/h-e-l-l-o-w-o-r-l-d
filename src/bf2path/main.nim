###########################
# LOOP START #  LOOP END  #
#            #            #
#   !/v\/    #     \/     #
#     \ /    #            #
#    \ \!    #    !//     #
###########################

import os
import re
from strutils import join

# print help message if requested
if paramCount() <= 0 or paramStr(1) == "help" or paramStr(1) == "--help" or paramStr(1) == "-h":
    echo("Usage:")
    echo(" ", paramStr(0), " [file]      | Convert [file] to brainfuck, print to stdout")
    quit(QuitSuccess)

# read and filter input
let bfCode_raw: string = readFile(paramStr(1))
let bfCode:     string = findAll(bfCode_raw, re(r"[+\-<>\[\].,]")).join

echo bfCode
