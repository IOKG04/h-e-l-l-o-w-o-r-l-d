import os
import re
from strutils import join

# print help message if requested
if paramCount() < 2:
    echo("Usage:")
    echo(" ", paramStr(0), " [in] [out]  | Convert [file] to brainfuck, write to [out]")
    quit(QuitFailure)

# read and filter [in]
let bfCode_raw: string = readFile(paramStr(1))
let bfCode:     string = findAll(bfCode_raw, re(r"[+\-<>\[\].,]")).join("")
let bfLoops:    string = findAll(bfCode, re(r"[\[\]]")).join("")

# get highest loop nest depth
var bfNestDepth:   int = 0
var bfNestDepth_c: int = 0
for c in bfLoops:
    if c == '[':
        bfNestDepth_c += 1
    elif c == ']':
        if bfNestDepth_c > bfNestDepth:
            bfNestDepth = bfNestDepth_c
        bfNestDepth_c = 0

# open [out]
let fOut: File = open(paramStr(2), FileMode.fmWrite)
#defer: fOut.close() or not cause ig top level defer is too complex 3:

# write main line
fOut.write('$')
for c in bfCode:
    case c:
        of '+':
            fOut.write('+')
        of '-':
            fOut.write('-')
        of '>':
            fOut.write('}')
        of '<':
            fOut.write('{')
        of '.':
            fOut.write('.')
        of ',':
            fOut.write(',')
        of '[':
            fOut.write("!/v\\/")
        of ']':
            fOut.write("  \\/")
        else:
            fOut.write(' ')
fOut.write("#\n")

# write transfer-0 line
fOut.write(' ')
for c in bfCode:
    case c:
        of '[':
            fOut.write("  \\ /")
        of ']':
            fOut.write("    ")
        else:
            fOut.write(' ')
fOut.write('\n')

# write transfer lines
for nestDepth in 0..(bfNestDepth - 1):
    bfNestDepth_c = 0
    fOut.write(' ')
    for c in bfCode:
        case c:
            of '[':
                if bfNestDepth_c == nestDepth:
                    fOut.write(" \\ \\!")
                else:
                    fOut.write("     ")
                bfNestDepth_c += 1
            of ']':
                bfNestDepth_c -= 1
                if bfNestDepth_c == nestDepth:
                    fOut.write(" !//")
                else:
                    fOut.write("    ")
            else:
                fOut.write(' ')
    fOut.write('\n')

# close [out]
fOut.close()
