import 'dart:async';
import 'water_reminder.dart';

void main() async {
  final reminder = WaterReminder();
  reminder.dailyTarget = 3;
  reminder.setReminderInterval(minutes: 30); // Set normal interval

  print('\n=== Test 1: Normal Mode ===');
  print('Initial setup with 30-minute interval');
  reminder.drink();
  reminder.checkReminder();

  print('\n=== Test 2: Test Mode ===');
  reminder.enableTestMode(); // Forces 5-second interval
  reminder.drink();

  // Start periodic checks
  var timer = Timer.periodic(
    const Duration(seconds: 2),
    (_) => reminder.checkReminder(),
  );

  // Wait for test interval to elapse
  await Future.delayed(const Duration(seconds: 6));
  reminder.checkReminder();

  print('\n=== Test 3: Back to Normal Mode ===');
  reminder.disableTestMode(); // Returns to 30-minute interval
  reminder.drink();
  reminder.checkReminder();

  // Clean up
  timer.cancel();
  print('\nTest complete - Test mode demonstration finished');
}
