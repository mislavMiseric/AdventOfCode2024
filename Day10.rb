f = File.open("resource/day10/test.txt", "r")
f.each_line do |line|
  puts line
end
f.close