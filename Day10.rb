$matrix = []

def hike(isPart1, row, col, matrix)
  #puts " " + $matrix[row][col] + " " + row.to_s + " " + col.to_s
  sum = 0
  if(Integer(matrix[row][col]) == 9)
    if(isPart1)
      matrix[row][col] = 'X'  
    end
    return 1
  end
  if (row+1 < matrix.length && matrix[row+1][col] != '.' && matrix[row+1][col] != 'X' && Integer(matrix[row+1][col]) == Integer(matrix[row][col]) + 1)
    sum += hike(isPart1, row+1, col, matrix)
  end
  if (row-1 >= 0 && matrix[row-1][col] != '.' && matrix[row-1][col] != 'X' && Integer(matrix[row-1][col]) == Integer(matrix[row][col]) + 1)
    sum += hike(isPart1, row-1, col, matrix)
  end
  if (col+1 < matrix[0].length - 1 && matrix[row][col+1] != '.' && matrix[row][col+1] != 'X' && Integer(matrix[row][col+1]) == Integer(matrix[row][col]) + 1)
    sum += hike(isPart1, row, col+1, matrix)
  end
  if (col-1 >= 0 && matrix[row][col-1] != '.' && matrix[row][col-1] != 'X' && Integer(matrix[row][col-1]) == Integer(matrix[row][col]) + 1)
    sum += hike(isPart1, row, col-1, matrix)
  end
  return sum
end

startPositions = []
startPositionsCounter = 0
lineCounter = 0

f = File.open("resource/day10/input.txt", "r")
f.each_line { |line|
  $matrix[lineCounter] = line
  positionsOfZero = (0 ... line.length).find_all { |i| line[i,1] == '0' }
  positionsOfZero.each { |x| 
    startPositions[startPositionsCounter]=lineCounter.to_s + "|" + x.to_s 
    startPositionsCounter += 1
  }
  lineCounter += 1
}
f.close

availableRoadsPart1 = 0
availableRoadsPart2 = 0

#puts $matrix

startPositions.each { |x| 
  availableRoadsPart1 += hike(true, Integer(x.split("|")[0]), Integer(x.split("|")[1]), $matrix.map(&:clone))
  availableRoadsPart2 += hike(false, Integer(x.split("|")[0]), Integer(x.split("|")[1]), $matrix.map(&:clone))  
}

puts availableRoadsPart1
puts availableRoadsPart2
