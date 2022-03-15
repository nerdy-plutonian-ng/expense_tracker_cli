import 'dart:convert';
import 'dart:io';


const String textFileName = 'expense_tracker.txt';

Future<String> getName () async {
  final textStream = utf8.decoder
      .bind(File(textFileName).openRead());
  String text = '';
  await for(var streamBit in textStream){
    text = text + streamBit;
  }
  final db = jsonDecode(text);
  return db['name'];
}

Future<Map<String,dynamic>> getDB () async {
  final textStream = utf8.decoder
      .bind(File(textFileName).openRead());
  String text = '';
  await for(var streamBit in textStream){
    text = text + streamBit;
  }
  final db = jsonDecode(text);
  return db;
}

Future<bool> isInUse() async {
  final isInUse =  await FileSystemEntity.isFile(textFileName);
  if(isInUse){
    final text = utf8.decoder
        .bind(File(textFileName).openRead());
    return !await text.isEmpty;
  }
  return false;
}

Future<bool> overWriteWithNewData(String newData) async {
try {
  final quotes = File(textFileName);
  await quotes.writeAsString(newData, mode: FileMode.write);
  return true;
} catch (e){
  stdout.writeln('Error saving');
  stdout.writeln(e);
  return false;
}
}