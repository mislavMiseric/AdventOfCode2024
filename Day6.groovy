import java.text.SimpleDateFormat

def file = new File('resource/day6/input.txt')
def countDistinctPasses = 1
def countLoops = 0
countLoopsGlobal = 0

if (file.exists()) {
    def date = new Date()
    def sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")

    def content = file.text.split('\n')
    (orientation, rowIndex, colIndex) = findGuardLocationAndCheckOrientation(content);
    content[rowIndex] = changeCharInString(content[rowIndex], colIndex, orientation)
    
    while(orientation != 0) { 
        (orientation, rowIndex, colIndex, content, countDistinctPasses, countLoops) = chechNextFieldAndRotateIfNeeded(orientation, rowIndex, colIndex, content, countDistinctPasses, countLoops, false)
    }
    content.eachWithIndex { line, row ->
        println line
    }
    def date2 = new Date()
    println "Start: " + sdf.format(date)
    println "End: " + sdf.format(date2)

    println 'Distinct fields passed: ' + countDistinctPasses
    println 'Possible loops: ' + countLoopsGlobal
} else {
    println "File does not exist."
}

def findGuardLocationAndCheckOrientation(content){
    def orientation
    def rowIndex
    def colIndex
    def found = false
    content.eachWithIndex { line, row ->
        if (found) return
        line.eachWithIndex { c, col -> 
            if (c == '^') {
                orientation = 1
                rowIndex = row
                colIndex = col
                found = true
                return
            } else if (c == '>'){
                orientation = 2
                rowIndex = row
                colIndex = col
                found = true
                return
            } else if (c == 'ˇ'){
                orientation = 3
                rowIndex = row
                colIndex = col
                found = true
                return
            } else if (c == '<'){
                orientation = 4
                rowIndex = row
                colIndex = col
                found = true
                return
            }
        }
    }
    return [orientation, rowIndex, colIndex]
}

def chechNextFieldAndRotateIfNeeded(orientation, rowPosition, colPosition, content, countDistinctPasses, countLoops, obstaclePlaced){
    newColPosition = colPosition
    newRowPosition = rowPosition
    if(orientation.equals(1)){
        newRowPosition = rowPosition - 1 
    } else if(orientation.equals(2)){
        newColPosition = colPosition + 1
    } else if(orientation.equals(3)){
        newRowPosition = rowPosition + 1 
    } else if(orientation.equals(4)){
        newColPosition = colPosition - 1
    }
    switch(checkField(newRowPosition, newColPosition, content)){
        case 0:
            return [0, rowPosition, colPosition, content, countDistinctPasses, false]
        case 1:
            if(orientation == 4) orientation = 0
            return [++orientation, rowPosition, colPosition, content, countDistinctPasses, false]
        case 2:
            if(content[newRowPosition][newColPosition].equals((String)orientation)) {
                return [orientation, newRowPosition, newColPosition, content, countDistinctPasses, true]
            }
            content[newRowPosition] = changeCharInString(content[newRowPosition], newColPosition, orientation)
            return [orientation, newRowPosition, newColPosition, content, countDistinctPasses, false]
        default:
            if(!obstaclePlaced){
                def newRowPositionCopy = newRowPosition
                def newColPositionCopy = newColPosition
                if(checkIfObstacleWillLoop(orientation, rowPosition, newRowPosition, colPosition, newColPosition, content)) ++countLoopsGlobal
                newColPosition = newColPositionCopy
                newRowPosition = newRowPositionCopy
            }
            content[newRowPosition] = changeCharInString(content[newRowPosition], newColPosition, orientation)
            return [orientation, newRowPosition, newColPosition, content, ++countDistinctPasses, false]
    }
}

def checkField(rowPosition, colPosition, content){
    if(content.size() <= rowPosition || rowPosition < 0|| content[0].length()-1 <= colPosition ||colPosition < 0){
        return 0
    }
    if(content[rowPosition][colPosition].equals('#')){
        return 1
    }
    if(content[rowPosition][colPosition].equals('1') || content[rowPosition][colPosition].equals('2') || content[rowPosition][colPosition].equals('3') || content[rowPosition][colPosition].equals('4')){
        return 2
    }
    return 3

}

def changeCharInString(content, index, c){
    return content.substring(0, index) + c + content.substring(index+1)
}


def checkIfObstacleWillLoop(orientation, rowPositionOld, rowPosition, colPositionOld, colPosition, content){
    def isLoop = false

    def contentCopy = new String[content.size()]
    content.eachWithIndex { line, row ->
        contentCopy[row] = line
    }

    println rowPositionOld + " " + colPositionOld
    contentCopy[rowPosition] = changeCharInString(content[rowPosition], colPosition, "#")
    
    while(orientation != 0 && !isLoop) { 
        (orientation, rowPositionOld, colPositionOld, contentCopy, countDistinctPasses, isLoop) = chechNextFieldAndRotateIfNeeded(orientation, rowPositionOld, colPositionOld, contentCopy, 0, 0, true)
    }
    
    return isLoop
}