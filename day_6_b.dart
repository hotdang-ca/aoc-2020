import 'dart:convert';
import 'dart:io';

void main() {
  File('day_6_input.txt').readAsString().then((rawStringData) {
    Iterable<String> lines = LineSplitter.split(rawStringData);
    int sumOfCounts = 0;

    Map<String, int> responses = new Map<String, int>();
    int personInGroupIndex = 0;

    for (String line in lines) {
      // each person

      // empty line means next group
      if (line.trim().isEmpty) {
        int commonResponses = 0;
        responses.forEach((key, value) {
          // if key value == group length, everyone had that as a yes response
          if (value == personInGroupIndex) {
            commonResponses += 1;
          }
        });
        // print('$commonResponses for this group');
        sumOfCounts += commonResponses;

        // cleanup
        responses = new Map<String, int>();
        personInGroupIndex = 0;
        continue;
      }

      personInGroupIndex += 1;
      
      // populate map with this persons responses
      for (int i = 0; i < line.length; i++) {
        String yesResponse = line[i];
        if (responses.containsKey(yesResponse)) {
          responses.update(yesResponse, (value) => ++value);
        } else {
          responses.putIfAbsent(yesResponse, () => 1);
        }
      }
    }

    // last line of last group. see above
    int commonResponses = 0;
    responses.forEach((key, value) {
      if (value == personInGroupIndex) {
        commonResponses += 1;
      }
    });

    sumOfCounts += commonResponses;

    print('Sum of all responses: $sumOfCounts');
  });
}