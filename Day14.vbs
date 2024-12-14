Set file = CreateObject("Scripting.FileSystemObject").OpenTextFile("resource/day14/input.txt",1)
Dim guards(500)
numberOfGuards = 0
seconds = 100

Const xSize = 101
Const ySize = 103

sumQuadrantI = 0
sumQuadrantII = 0
sumQuadrantIII = 0
sumQuadrantIV = 0

do while not file.AtEndOfStream
     guards(numberOfGuards) = file.ReadLine()
     numberOfGuards = numberOfGuards + 1
loop

file.Close
Set file = Nothing


'part 1
For i = 0 to (numberOfGuards - 1)
     'p=0,4 v=3,-3
     guards(i) = Replace(guards(i), "p=", "")
     guards(i) = Replace(guards(i), "v=", "")
     guards(i) = Replace(guards(i), ",", " ")
     numbers = Split(guards(i), " ")

     x = (numbers(0) + numbers(2) * seconds) Mod xSize
     y = (numbers(1) + numbers(3) * seconds) Mod ySize

     if(x < 0) THEN
          x = (xSize + x) Mod xSize
     End If
     if(y < 0) THEN

          y = (ySize + y) Mod ySize
     End If

     'ignore middle row and col for example size is 9, it will ignore 5th (index 4) element because of CINT
     if x < CINT(xSize/2 -0.1) Then
          if y < CINT(ySize/2 -0.1) Then
               sumQuadrantI = sumQuadrantI + 1
          ElseIf y >= ySize/2 Then
               sumQuadrantIV = sumQuadrantIV + 1
          End If
     End If

     if x >= xSize/2 Then
          if y < CINT(ySize/2 -0.1) Then
               sumQuadrantII = sumQuadrantII + 1
          ElseIf y >= ySize/2 Then
               sumQuadrantIII = sumQuadrantIII + 1
          End If
     End If
Next

WScript.Echo "Part1 result: " & sumQuadrantI * sumQuadrantII * sumQuadrantIII * sumQuadrantIV

'part 2
ReDim picture(xSize, ySize)
Dim xPos(500)
Dim yPos(500)
Dim xVel(500)
Dim yVel(500)

For i = 0 to (100000)

     ReDim picture(xSize, ySize)

     For j = 0 to (numberOfGuards - 1)
          If(i = 0) THEN
               numbers = Split(Replace(guards(j), ",", " "), " ")
               xPos(j) = CINT(numbers(0))
               yPos(j) = CINT(numbers(1))
               xVel(j) = CINT(numbers(2))
               yVel(j) = CINT(numbers(3))
          Else 
               xPos(j) = (xPos(j) + xVel(j)) Mod xSize
               yPos(j) = (yPos(j) + yVel(j)) Mod ySize

               if(xPos(j) < 0) THEN
                    xPos(j) = (xSize + xPos(j)) Mod xSize
               End If
               if(yPos(j) < 0) THEN
                    yPos(j) = (ySize + yPos(j)) Mod ySize
               End If
          End If
          picture(xPos(j), yPos(j)) = "x"
     Next

     If SearchForChristmasTree(picture, i) THEN
          Exit For
     End If

Next

WScript.Echo "Part2: " & i & " seconds"

Function SearchForChristmasTree(picture, i)

     SearchForChristmasTree = False

     foundX = 0
     foundY = 1
     firstX = -1
     lastX = -1
     firstY = -1
     lastY = -1

     For p = 0 To ySize - 1
          For q = 0 To xSize -1 
               If(lastX = -1) THEN
                    If(picture(q, p) = "x") THEN
                         If(foundX = 0) THEN
                              firstX = q
                              firstY = p
                         End If
                         foundX = foundX + 1
                    Else
                         If(foundX>5) THEN
                              lastX = q-1
                         ElseIf(lastX=-1) THEN
                              ResetValues foundX, foundY, firstX, lastX, firstY, lastY
                         End If
                    End If
               End If
               If((firstX <> -1) And (lastX <> -1) And p > firstY) THEN
                    If((q = firstX)) THEN
                         If(picture(q, p) = "x") THEN
                              foundY = foundY + 1
                         ElseIf(foundY>5) THEN
                              lastY = p-1
                         ElseIf(lastY=-1) THEN
                              ResetValues foundX, foundY, firstX, lastX, firstY, lastY
                         End If
                    ElseIf((q = lastX)) THEN
                         If(picture(q, p) <> "x") Then
                              If(lastY+1 = p) Then
                                   SearchForChristmasTree = True
                                   For r = firstY To lastY 
                                        For k = firstX To lastX
                                             If(picture(k, r) = "x") THEN
                                                  WScript.stdout.write picture(k, r)
                                             Else
                                                  WScript.stdout.write " "
                                             End If
                                        Next
                                        Wscript.Echo ""
                                   Next
                                   Exit Function
                              Else
                                   ResetValues foundX, foundY, firstX, lastX, firstY, lastY
                              End If
                         End If
                    End If
               End If
          Next
     Next

     if(i Mod 100 = 0) Then
          Wscript.Echo i
     End If

     
End Function

Sub ResetValues(ByRef foundX, ByRef foundY, ByRef firstX, ByRef lastX, ByRef firstY, ByRef lastY)
     foundX = 0
     foundY = 1
     firstX = -1
     lastX = -1
     firstY = -1
     lastY = -1
End Sub