import 'dart:io';
import 'utilities.dart';
import 'onboarding.dart';
import 'transactions.dart';

start() async {
  if(await isInUse()){
    showTransactionsMenu();
  } else {
    if(await onboard()){
      showTransactionsMenu();
    } else {
      stdout.write('Error occurred bringing you onboard. Restarting app!');
      start();
    }
  }
}
