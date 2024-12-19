import 'dart:io';
import 'dart:convert';
import 'dart:async';

const int size = 71;
const int endX = size - 1;
const int endY = size - 1;
List<List<int>> memorySpace = List.generate(
  size,
  (_) => List.filled(size, -1)
);

void moveIntoMemory(int yPosition, int xPosition, int counter){
  if(yPosition < 0 || yPosition > size -1 || xPosition < 0 || xPosition > size -1 || memorySpace[yPosition][xPosition] == -2){
    return;
  }
  if(memorySpace[yPosition][xPosition] == -1 || memorySpace[yPosition][xPosition] > counter){
    memorySpace[yPosition][xPosition] = counter;
      moveIntoMemory(yPosition + 1, xPosition, counter + 1);
      moveIntoMemory(yPosition - 1, xPosition, counter + 1);
      moveIntoMemory(yPosition, xPosition + 1, counter + 1);
      moveIntoMemory(yPosition, xPosition - 1, counter + 1);
      
  }
  return;
}

void main() async {
  int counter = 0;
  final file = File('resource/day18/input.txt');
  Stream<String> lines = file.openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter());
  try {
    await for (var line in lines) {
      var parts = line.split(',');

      int x = int.parse(parts[0]);
      int y = int.parse(parts[1]);

      memorySpace[y][x] = -2;

      List<List<int>> backupMemorySpace = memorySpace.map((row) => List<int>.from(row)).toList();

      moveIntoMemory(0,0,0);

      if(memorySpace[endY][endX] < 0){
        print("$x,$y");
        break;
      }

      memorySpace = backupMemorySpace.map((row) => List<int>.from(row)).toList();

      print(++counter);
    }
  } catch (e) {
    print('Error: $e');
  }

}