
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

  bool get birthYearIsValid {
    if (byr == null) return false;

    int birthYear = int.parse(byr);
    if (birthYear == null) return false;

    return (birthYear >= 1920 && birthYear <= 2002);
  }

  bool get issueYearIsValid {
    if (iyr == null) return false;

    int issueYear = int.parse(iyr);
    if (issueYear == null) return false;

    return (issueYear >= 2010 && issueYear <= 2020);
  }

  bool get expirationYearIsValid {
    if (eyr == null) return false;

    int expirationYear = int.parse(eyr);
    if (expirationYear == null) return false;

    return (expirationYear >= 2020 && expirationYear <= 2030);
  }

  bool get heightIsValid {
    if (hgt == null) return false;
    // TODO: should be a regex
    if (hgt.contains('cm')) {
      int heightInCm = int.parse(hgt.split('cm')[0]);
      if (heightInCm == null) return false;
      return heightInCm >= 150 && heightInCm <= 193;
    } else if (hgt.contains('in')) {
      int heightInIn = int.parse(hgt.split('in')[0]);
      if (heightInIn == null) return false;
      return heightInIn >= 59 && heightInIn <= 76;
    } else {
      return false;
    }
  }

  bool get hairColorIsValid {
    if (hcl == null) return false;
    return RegExp(r"^#[0-9a-zA-Z]{6}$").hasMatch(hcl);
  }

  bool get eyeColorIsValid {
    if (ecl == null) return false;
    List<String> validEyeColors = ['amb','blu','brn','gry','grn','hzl','oth'];
    return validEyeColors.contains(ecl);
  }

  bool get passportIdIsValid {
    if (pid == null) return false;
    return RegExp(r"^[0-9]{9}$").hasMatch(pid);
  }

  bool get isInvalid => 
    !birthYearIsValid
    || !issueYearIsValid 
    || !expirationYearIsValid
    || !heightIsValid
    || !hairColorIsValid
    || !eyeColorIsValid
    || !passportIdIsValid;
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