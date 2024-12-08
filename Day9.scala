def main(args: Array[String]) = {
    val source = scala.io.Source.fromFile("resource/day9/test.txt")
    val lines = try source.mkString finally source.close()

    println(lines)
}