import 'dart:convert';
import 'dart:io';

void main() {
  File('day_6_input.txt').readAsString().then((rawStringData) {
    Iterable<String> lines = LineSplitter.split(rawStringData);
    int sumOfCounts = 0;

    Set<String> responses = new Set<String>();
    for (String line in lines) {
      if (line.trim().isEmpty) {
        // next person
        sumOfCounts += responses.length;
        responses = new Set<String>();
        continue;
      }

      for (int i = 0; i < line.length; i++) {
        responses.add(line[i]);
      }
    }

    // handle the last line... FIXME:
    sumOfCounts += responses.length;
    print('Sum of all unique Yes responses: ${sumOfCounts}');
  });
}