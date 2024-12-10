import scala.util.control.Breaks._
import scala.math.pow

def main(args: Array[String]) = {
    val source = scala.io.Source.fromFile("resource/day9/input.txt")
    var sum = 0.toLong
    for (line <- source.getLines())
        //println(line)
        val convertedDiskMapLine = convertDiskMap(line)
        //println("------------------")
        //println(convertedDiskMapLine)
        val formatedLine = formatLine(convertedDiskMapLine)
        //println("------------------")
        println(formatedLine)
        sum += calculateChecksum(formatedLine)
    source.close()
    println("Sum: " + sum)
}

def convertDiskMap(line: String): String = {
    var convertedLine = ""
    var counter = 0
    for(i <- 0 until line.size by 2){
        convertedLine += ("X" + counter + "X") * (line(i).asDigit)
        if(i+1 < line.size){
            convertedLine += "." * line(i+1).asDigit
        }
        counter += 1
    }
    return convertedLine

}

def formatLine(line: String): String = {
    var newLine = ""
    var counter = 0

    breakable { for (i <- 0 until line.size){
        if(i > line.size-1-counter){
            break
        }
        if(line(i) != '.'){
            newLine += line(i)
        } else {
            while(line(line.size-1-counter) == '.'){
                counter += 1
            }
            if(i > line.size-1-counter){
                break
            }
            val fileIdToMove = line.substring(line.lastIndexOf('X', line.size-2-counter), line.size-counter)
            //println(fileIdToMove)
            newLine += fileIdToMove
            counter += fileIdToMove.size
            
        }
    } }

    return newLine
}

def calculateChecksum(line: String): Long = {
    var result = 0.toLong
    var i = 0
    var counter = 0
    while(i < line.size){
        val fileIdString = line.substring(i+1, line.indexOf('X', i+2))
        val fileId = fileIdString.toInt
        result += fileId * counter
        println(" " + fileId + " * " + counter + " = " + (fileId * counter))
        counter += 1
        i += fileIdString.length + 2
    }

    return result
}