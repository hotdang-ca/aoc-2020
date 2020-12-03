import 'dart:convert';
import 'dart:io';

class Position {
  int x;
  int y;

  Position({
    this.x,
    this.y,
  });

  void move({ int deltaX, int deltaY }) {
    x += deltaX;
    y += deltaY;
  }

  String current() {
    return 'X: $x, Y: $y';
  }
}

Future<List<String>> mapArray(String inputPath) {
  try {
    return File(inputPath)
      .openRead()
      .transform(utf8.decoder)
      .transform(new LineSplitter())
      .toList();
  } catch (e) {
    print('error!\n$e');
    return null;
  }
}

String readMap(List<String> map, Position position) {
  if (map.length <= position.y) { // we reached the end!
    return null;
  }

  String yTopology = map[position.y];

  if (yTopology.length < position.x) {
    // beyond the x position; repeat the sequence to the right
    // how much past are we?
    int extraX = position.x - yTopology.length;
    
    while(extraX >= yTopology.length) {
      extraX = extraX - yTopology.length;
    }

    return yTopology[extraX];
  }

  String xTopology = yTopology[position.x];
  return('$xTopology'); // the char at position
}

main() async {
  List<String> map;

  try {
    map = await mapArray('day_3_input.txt');
  } catch (e) {
    print('Could not open that file.');
  }

  Position sledPosition = Position(x: 0, y: 0);
  String currentPositionCode = readMap(map, sledPosition);
  int treesHit = 0;
  while (currentPositionCode != null) {
    sledPosition.move(deltaX: 3, deltaY: 1);
    currentPositionCode = readMap(map, sledPosition);

    if (currentPositionCode == '#') {
      treesHit += 1;
    }
  }

  print('Reached the last coordinate. $treesHit hit.');
}

