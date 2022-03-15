import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/constants.dart';
import 'package:intl/intl.dart';

import 'utilities.dart';

showTransactionsMenu() async {
  stdout.writeln('Hi, ${await getName()}');
  stdout.writeln('1. Record an Expense');
  stdout.writeln('2. View Report');
  stdout.writeln('99. Exit');
  try {
    stdout.writeln('Enter option please');
    final result = int.parse(stdin.readLineSync()!);
    processMenuOption(result);
  } catch (e) {
    stdout.writeln('Invalid option');
    showTransactionsMenu();
  }
}

processMenuOption(int option) {
  switch (option) {
    case 1:
      recordAnExpense();
      break;
    case 2:
      viewReport();
      break;
    case 99:
      exitApp();
      break;
    default:
      stdout.writeln('Invalid option');
      showTransactionsMenu();
      break;
  }
}

recordAnExpense() {
  var count = 1;
  for (var category in defaultCategories) {
    stdout.writeln('$count. $category');
    count++;
  }
  stdout.writeln('99. Back');
  stdout.writeln('Please select category to transact on');
  try {
    final result = int.parse(stdin.readLineSync()!);
    processRecordAnExpenseOption(result);
  } catch (e) {
    stdout.writeln('Invalid option');
    recordAnExpense();
  }
}

processRecordAnExpenseOption(int option) {
  if (option == 99) {
    showTransactionsMenu();
  } else if (option > 7) {
    stdout.writeln('Invalid option');
    recordAnExpense();
  } else {
    askExpenditure(
      defaultCategories[option - 1],
    );
  }
}

askExpenditure(
  String category,
) async {
  try {
    stdout.writeln('How much did you spend?');
    final expense = double.parse(stdin.readLineSync()!);
    final db = await getDB();
    if(db.containsKey('db')){
      if ((db['db'] as Map<String,dynamic>)
          .keys
          .contains(DateFormat.yMd().format(DateTime.now()))) {
        if ((db['db'][DateFormat.yMd().format(DateTime.now())]
        as Map<String, dynamic>)
            .containsKey(category)) {
          db['db'][DateFormat.yMd().format(DateTime.now())][category] = db['db']
          [DateFormat.yMd().format(DateTime.now())][category] +
              expense;
        } else {
          db['db'][DateFormat.yMd().format(DateTime.now())][category] = expense;
        }
      } else {
        db['db'][DateFormat.yMd().format(DateTime.now())] = <String,dynamic>{category : expense};
      }
    } else {
      db['db'] = <String,dynamic>{
        DateFormat.yMd().format(DateTime.now()) : <String,dynamic>{category : expense}
      };
    }
    stdout.writeln(
        'Expense of ${NumberFormat('#,###.00').format(expense)} added to $category');
    await overWriteWithNewData(jsonEncode(db));
    recordAnExpense();
  } catch (e) {
    stdout.writeln('Error saving');
    stdout.writeln(e.toString());
    askExpenditure(category);
  }
}

viewReport() async {
  try {
    stdout.writeln('Enter day you will like to view(yyyy-mm-dd)');
    stdout.writeln('99. Back');
    final searchDate = stdin.readLineSync()!;
    if (searchDate == '99') {
      showTransactionsMenu();
      return;
    }
    final dateStr = DateFormat.yMd().format(DateTime.parse(searchDate));
    final db = (await getDB())['db'] as Map<String, dynamic>;
    if(db.containsKey(dateStr)){
      final dayTransactions = db[dateStr] as Map<String, dynamic>;
      displayReport(dayTransactions);
      showTransactionsMenu();
      return;
    } else {
      stdout.writeln('You have no data on that day');
      viewReport();
    }

  } catch (e) {
    stdout.writeln("Error");
    stdout.writeln(e);
    viewReport();
  }
}

displayReport(Map<String, dynamic> dayTransactions) {
  double sum = 0;
  stdout.writeln();
  for(var expense in dayTransactions.entries){
    sum += expense.value as double;
    stdout.writeln('${expense.key} : ${NumberFormat('#,###.00').format(expense.value)}');
  }
  stdout.writeln();
  stdout.writeln('Total Expense : ${NumberFormat('#,###.00').format(sum)}');
  stdout.writeln();
}

exitApp() {
  stdout.writeln('Good Bye!!!');
  Future.delayed(Duration(seconds: 3),(){
    exit(0);
  });

}
