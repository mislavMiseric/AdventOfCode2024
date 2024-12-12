Set file = CreateObject("Scripting.FileSystemObject").OpenTextFile("resource/day14/test.txt",1)

do while not file.AtEndOfStream
     WScript.Echo file.ReadLine()
loop

file.Close
Set file = Nothing