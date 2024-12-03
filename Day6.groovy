def file = new File('resource/day6/test.txt')

if (file.exists()) {
    def content = file.text
    println content
} else {
    println "File does not exist."
}