import std/strutils
import algorithm

proc executeLine(line: string, patterns: seq[string]): bool =
    if(len(line)==0): 
        return true
    #echo line
    for pattern in patterns:
        if(len(pattern) <= len(line)):
            if(line.startsWith(pattern)):
                if(executeLine(line[pattern.len .. ^1], patterns)):
                    return true
    return false

    

var isFirstLine = true
var possiblePatterns: seq[string]
var uniquePatterns: seq[string]
var counter = 0
var numberOfLines = 0

for line in lines "resource/day19/input.txt":
    if(isFirstLine):
        isFirstLine = false;
        possiblePatterns = line.split(", ")
        possiblePatterns.sort(proc(a, b: string): int = cmp(len(b), len(a)))
        for i, pattern in possiblePatterns:
            if(not (i < len(possiblePatterns)-1 and executeLine(pattern, possiblePatterns[i+1 .. ^1]))):
                uniquePatterns.add(pattern)
        echo len(uniquePatterns)
        continue
    if(len(line)==0):
        continue
    if(executeLine(line, uniquePatterns)):
        inc counter
    inc numberOfLines
    echo numberOfLines
    
echo "\nCorrect lines: " & $counter
