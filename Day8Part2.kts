import java.io.File

executeTask("resource/day8/test.txt")

fun executeTask(fileName: String) {

    var content = File(fileName).readLines()
    val frequencyMap = createFrequencyMap(content)
    processFrequencyMap(frequencyMap, content.size, content[0].length)

}

fun createFrequencyMap(content: List<String>): Map<Char, List<Pair<Int, Int>>> {

    val frequencyMap = mutableMapOf<Char, MutableList<Pair<Int, Int>>>()
    
    content.forEachIndexed { lineIndex, line ->
        line.forEachIndexed { charIndex, char ->
            if (char.isLetterOrDigit()) {
                frequencyMap.computeIfAbsent(char) { mutableListOf() }
                    .add(Pair(lineIndex, charIndex))
            }
        }
    }

    return frequencyMap

}


fun processFrequencyMap(frequencyMap: Map<Char, List<Pair<Int, Int>>>, numberOfLines: Int, lineSize: Int) {

    val antinodesSet = mutableSetOf<Pair<Int, Int>>()

    frequencyMap.forEach { (key, positions) ->
        println("Processing key: $key")
        positions.forEachIndexed { currentIndex, currentFrequency ->

            println("   Current Frequency: $currentFrequency")

            for (nextIndex in currentIndex + 1 until positions.size) {

                val nextFrequency = positions[nextIndex]

                val diffLineIndex = nextFrequency.first - currentFrequency.first
                val diffCharIndex = nextFrequency.second - currentFrequency.second

                var firstAntinode = nextFrequency
                var secondAntinode = currentFrequency

                while(firstAntinode.first < numberOfLines && firstAntinode.second in 0..(lineSize-1)){
                    antinodesSet.add(firstAntinode)
                    firstAntinode = Pair(diffLineIndex + firstAntinode.first, diffCharIndex + firstAntinode.second)
                }

                while(secondAntinode.first >= 0 && secondAntinode.second in 0..(lineSize-1)){
                    antinodesSet.add(secondAntinode)
                    secondAntinode = Pair(secondAntinode.first - diffLineIndex, secondAntinode.second - diffCharIndex)
                }
            }
        }
    }
    println(antinodesSet.size)
}