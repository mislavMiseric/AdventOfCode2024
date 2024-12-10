import scala.util.control.Breaks._
import scala.math.pow

def main(args: Array[String]) = {
    val source = scala.io.Source.fromFile("resource/day9/input.txt")
    var sum = 0.toLong
    for (line <- source.getLines())
        println(line)
        sum += calculate(line)
    source.close()
    println("Sum: " + sum)
}

def calculate(line: String): Long = {
    var tempLine = line
    var indexChecksum = 0
    var oddLastIndex = 0
    var checksum = 0.toLong

    if(line.size % 2 == 0){
        oddLastIndex = line.size - 2
    } else {
        oddLastIndex = line.size - 1
    }

    for(i <- 1 until line.size by 2){
        var tempOddLastIndex = oddLastIndex
        checksum += calculateChecksum(indexChecksum,tempLine(i-1).asDigit, (i-1)/2)
        indexChecksum += line(i-1).asDigit
        var tempIndexChecksum = 0
        while(tempLine(i).asDigit > 0 && tempOddLastIndex > i){
            if(tempLine(tempOddLastIndex).asDigit > 0 && tempLine(i).asDigit >= tempLine(tempOddLastIndex).asDigit){
                checksum += calculateChecksum(indexChecksum + tempIndexChecksum, tempLine(tempOddLastIndex).asDigit, tempOddLastIndex/2)
                tempIndexChecksum += tempLine(tempOddLastIndex).asDigit

                tempLine = replaceCharAtIndex(tempLine, (tempLine(i).asDigit - tempLine(tempOddLastIndex).asDigit), i)
                tempLine = replaceCharAtIndex(tempLine, 0, tempOddLastIndex)
            }
            tempOddLastIndex -= 2
        }
        indexChecksum += line(i).asDigit
    }
    return checksum

}

def replaceCharAtIndex(line: String, c: Int, i: Int): String = {
    return line.substring(0, i) + c + line.substring(i + 1)
}

def calculateChecksum(start: Int, ocurrencies: Int, value: Int): Long = {
    var sum = 0.toLong
    for(i <- start until start + ocurrencies){
        println(" " + i + " * " + value + " = " + (i * value))
        sum += i * value
    }
    return sum
}
