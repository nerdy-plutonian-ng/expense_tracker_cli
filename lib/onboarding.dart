import 'dart:io';
import 'dart:convert';

import 'package:expense_tracker/utilities.dart';
import 'constants.dart';

onboard() async {
  try {
    stdout.writeln('Hi, User');
    stdout.writeln('Welcome to Expense Tracker CLI');
    var name = '';
    do {
      stdout.writeln('What is your name?');
      name = stdin.readLineSync()!;
    } while (name.isEmpty);
    final dbMap = <String,dynamic>{'name':name};
    stdout.writeln('App starting with these categories...');
    stdout.writeln(defaultCategories);
    stdout.writeln(dbMap);
    final textFile = File(textFileName).openWrite(mode: FileMode.append);
    textFile.writeln(jsonEncode(dbMap));
    await textFile.close();
    return true;
  } catch(e){
    print(e);
    return false;
  }
}