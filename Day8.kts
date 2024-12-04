import java.io.File

readFileLineByLineUsingForEachLine("resource/day8/test.txt")

fun readFileLineByLineUsingForEachLine(fileName: String) 
  = File(fileName).forEachLine { println(it) }