import std/strutils
import algorithm
import tables

var resultsCached = initTable[string, int]()

proc executeLine(line: string, patterns: seq[string]): int =
    if(len(line)==0): 
        return 1
    var found = 0
    if resultsCached.hasKey(line):
        return resultsCached[line]
    for pattern in patterns:
        if(len(pattern) > len(line)):
            continue
        if(line[0] > pattern[0]):
            continue
        if(line[0] < pattern[0]):
            resultsCached[line] = found
            return found
        if(line.startsWith(pattern)):
            found = found + executeLine(line[pattern.len .. ^1], patterns)
    resultsCached[line] = found
    return found    

    

var isFirstLine = true
var possiblePatterns: seq[string]
var counter = 0
var numberOfLines = 0

for line in lines "resource/day19/input.txt":
    if(isFirstLine):
        isFirstLine = false;
        possiblePatterns = line.split(", ")
        possiblePatterns.sort()
        continue
    if(len(line)==0):
        continue
    counter = counter + executeLine(line, possiblePatterns)
    inc numberOfLines
    echo $numberOfLines & " " & $counter

echo "Result: " & $counter
