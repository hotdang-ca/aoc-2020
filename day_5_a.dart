
import 'dart:convert';
import 'dart:io';

void main() async {
  int largestSeatId = 0;
  String rawStringData = await File('day_5_input.txt').readAsString();
  Iterable<String> lines = LineSplitter.split(rawStringData);

  for (String seatCode in lines) {
    List<int> rows = new List<int>();
    for (int idx = 0; idx <= 127; idx++) {
      rows.add(idx);
    }

    List<int> cols = new List<int>();
    for (int idx = 0; idx <= 7; idx++) {
      cols.add(idx);
    }

    for (int seatIndex = 0; seatIndex < seatCode.length; seatIndex++) {
      String seatChar = seatCode[seatIndex];

      switch (seatChar) {
        case 'F':
          // take the lower half
          int upperBound = rows.length ~/ 2;
          rows = rows.sublist(0, upperBound);
          break;
        case 'B':
          // take the upper half
          int lowerBound = rows.length ~/ 2;
          rows = rows.sublist(lowerBound, rows.length);
          break;
        case 'L':
          int upperBound = cols.length ~/ 2;
          cols = cols.sublist(0, upperBound);
          break;
        case 'R':
          int lowerBound = cols.length ~/ 2;
          cols = cols.sublist(lowerBound, cols.length);
          break;
      }
    }

    if (rows.length > 1 || cols.length > 1) {
      print('We did not reduce enough.');
    }

    int seatId = rows[0] * 8 + cols[0];
    if (seatId > largestSeatId) {
      largestSeatId = seatId;
    }
  }
  
  print('Largest seatId: $largestSeatId');
}