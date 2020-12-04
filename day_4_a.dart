
import 'dart:convert';
import 'dart:io';

class Passport {
  String byr;
  String iyr;
  String eyr;
  String hgt;
  String hcl;
  String ecl;
  String pid;
  String cid; // Optional

  Passport({
    this.byr,
    this.iyr,
    this.eyr,
    this.hgt,
    this.hcl,
    this.ecl,
    this.pid,
    this.cid,
  });

  bool get isInvalid => 
    byr == null 
    || iyr == null 
    || eyr == null 
    || hgt == null 
    || hcl == null
    || ecl == null
    || pid == null;
}

Future<List<Passport>> mapPassportsFromFile(String inputPath) async {
  List<Passport> passports = new List<Passport>();

  try {
    String rawStringData = await File(inputPath).readAsString();
    // we'll do our own parsing.
    Iterable<String> lines = LineSplitter.split(rawStringData);

    passports.add(Passport());
    for (String line in lines) {
      if (line.trim().isEmpty) {
        passports.add(Passport());
        continue;
      }

      Passport currentPassport = passports[passports.length - 1];

      List<String> lineParts = line.split(' ');
      if (lineParts.isNotEmpty) {
        for (String linePart in lineParts) {
          List<String> passportParts = linePart.split(':');
          switch(passportParts[0]) {
              case 'byr':
                currentPassport.byr = passportParts[1];
                break;
              case 'iyr':
                currentPassport.iyr = passportParts[1];
                break;
              case 'eyr':
                currentPassport.eyr = passportParts[1];
                break;
              case 'hgt':
                currentPassport.hgt = passportParts[1];
                break;
              case 'hcl':
                currentPassport.hcl = passportParts[1];
                break;
              case 'ecl':
                currentPassport.ecl = passportParts[1];
                break;
              case 'pid':
                currentPassport.pid = passportParts[1];
                break;
              case 'cid':
                currentPassport.cid = passportParts[1];
                break;
              default:
                print('Some other part found! ${passportParts[0]}');
            }
        }
      } else {
        // the line only had one field
        List<String> passportParts = line.split(':');
        switch(passportParts[0]) {
          case 'byr':
            currentPassport.byr = passportParts[1];
            break;
          case 'iyr':
            currentPassport.iyr = passportParts[1];
            break;
          case 'eyr':
            currentPassport.eyr = passportParts[1];
            break;
          case 'hgt':
            currentPassport.hgt = passportParts[1];
            break;
          case 'hcl':
            currentPassport.hcl = passportParts[1];
            break;
          case 'ecl':
            currentPassport.ecl = passportParts[1];
            break;
          case 'pid':
            currentPassport.pid = passportParts[1];
            break;
          case 'cid':
            currentPassport.cid = passportParts[1];
            break;
          default:
            print('Some other part found! ${passportParts[0]}');
        }
      }
    }

    return passports;

  } catch (e) {
    print('error!\n$e');
    return null;
  }
}

void main() {
  mapPassportsFromFile('day_4_input.txt').then((passports) {
    print('number of passports ${passports.length}');

    int validPassports = 0;
    int invalidPassports = 0;
    for (Passport passport in passports) {
      if (passport.isInvalid) {
        invalidPassports += 1;
      } else {
        validPassports += 1;
      }
    }

    print('Valid: $validPassports, invalid: $invalidPassports');
  });
}