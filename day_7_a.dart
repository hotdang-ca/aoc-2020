import 'dart:convert';
import 'dart:io';

void main() {
  File('input_cache/day_7_input.txt').readAsString().then((rawStringData) {
    Map<String, List<String>> ruleSet = new Map<String, List<String>>();

    Iterable<String> lines = LineSplitter.split(rawStringData);
    // 1. separate rule name from definition
    for (String line in lines) {
      List<String> lineParts = line.split(' contain ');
      
      String rule = lineParts.elementAt(0);
      String ruleDefinition = lineParts.elementAt(1);

      ruleSet.putIfAbsent(rule, () {
        // parse rule definitions
        List<String> definitions = ruleDefinition.split(',');
        
        // cleanup
        for (int index = 0; index < definitions.length; index++) {
          definitions[index] = definitions[index].trim().replaceAll('.', '');
        }

        return definitions;
      });
    }
    
    print('${ruleSet.length} rules parsed');

    Set<String> possibilities = new Set<String>();

    // what can directly contain a 'shiny gold' bag?
    List<String> directlyContains = new List<String>();
    ruleSet.forEach((String ruleName, List<String> rules) {
      for (String rule in rules) {
        if (rule.contains('shiny gold')) {
          // String howManyShinyGoldBags = rule[0];
          // print('$ruleName can contain $howManyShinyGoldBags shiny gold bag(s)');
          directlyContains.add(ruleName);
        }
      }
    });

    // TODO: need to traverse DEEP and potentially recursively for this one...
    List<String> eventuallyContains = new List<String>();
    // of those bags that can directly contain a shiny gold bag, which bags can contain it?
    ruleSet.forEach((String ruleName, List<String> rules) {
      for (String rule in rules) {
        for (String directBag in directlyContains) {
          // prepare for comparison
          
          String sanitizedRuleString = rule.replaceAll('bags', '').replaceAll('bag', '').trim();
          String sanitizedDirectString = directBag.replaceAll('bags', '').replaceAll('bag', '').trim();

          if (sanitizedRuleString.contains(sanitizedDirectString)) {
            // print('$ruleName contain $directBag, which can contain shiny gold bag.');
            eventuallyContains.add(ruleName);
            
          }
        }
      }
    });

    // tally up a unique set of coloured bags that could eventually contain shiny gold bags
    for (String direct in directlyContains) {
      String sanitized = direct.replaceAll('bags', '').replaceAll('bag', '').trim();
      possibilities.add(sanitized);
    }

    // TODO: I'd likely not need this, if I did the population of the array properly.
    for (String eventually in eventuallyContains) {
      String sanitized = eventually.replaceAll('bags', '').replaceAll('bag', '').trim();
      possibilities.add(sanitized);
    }

    print(possibilities.length);
  });
    
}