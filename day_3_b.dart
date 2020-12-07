import 'dart:convert';
import 'dart:io';

class Slope {
  int deltaX;
  int deltaY;
  int treesHit;

  String get name => 'Slope $deltaX:$deltaY';

  void hitATree() {
    treesHit += 1;
  }

  Slope({
    this.deltaX,
    this.deltaY,
  }) {
    treesHit = 0;
  }
}

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

  void reset() {
    x = 0;
    y = 0;
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

  if (yTopology.length <= position.x) {
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
    map = await mapArray('input_cache/day_3_input.txt');
  } catch (e) {
    print('Could not open that file.');
  }

  Position sledPosition = Position(x: 0, y: 0);
  List<Slope> slopes = new List<Slope>();
  slopes.add(new Slope(deltaX: 1, deltaY: 1));
  slopes.add(new Slope(deltaX: 3, deltaY: 1));
  slopes.add(new Slope(deltaX: 5, deltaY: 1));
  slopes.add(new Slope(deltaX: 7, deltaY: 1));
  slopes.add(new Slope(deltaX: 1, deltaY: 2));

  for (Slope slope in slopes) {
    print('Sledding with slope ${slope.name}');
    String currentPositionCode = readMap(map, sledPosition);

    while (currentPositionCode != null) {
      sledPosition.move(deltaX: slope.deltaX, deltaY: slope.deltaY);
      currentPositionCode = readMap(map, sledPosition);

      if (currentPositionCode == '#') {
        slope.hitATree();
      }
    }

    print('Reached the last coordinate for ${slope.name}. ${slope.treesHit} hit.');
    sledPosition.reset();
  }

  int productOfTreesHit = 1;
  slopes.forEach((slope) {
    productOfTreesHit *= slope.treesHit;
  });

  print('Weird trees hit productOfTreesHit: $productOfTreesHit');
}

