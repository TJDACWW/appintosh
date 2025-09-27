import 'package:flutter/material.dart';
import 'water_reminder.dart';

void main() {
  runApp(const MyApp());

  // --- WaterReminder test code ---
  var reminder = WaterReminder();
  reminder.drink();
  reminder.drink();
  print('Current glass count: ${reminder.glassCount}');
  reminder.reset();
  print('Glass count after reset: ${reminder.glassCount}');
  // -------------------------------
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Reminder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Water Reminder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _reminder = WaterReminder();
  late final TextEditingController _targetController;
  final _hoursController = TextEditingController(text: '2');
  final _minutesController = TextEditingController(text: '0');
  final _secondsController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _targetController = TextEditingController(text: _reminder.dailyTarget.toString());
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _drinkWater() {
    setState(() {
      _reminder.drink();
    });
  }

  bool _isValidTarget(String? value) {
    if (value == null || value.isEmpty) return true;
    final target = int.tryParse(value);
    return target != null && target > 0;
  }

  void _updateDailyTarget(String value) {
    if (_isValidTarget(value)) {
      final target = int.tryParse(value);
      if (target != null && target > 0) {
        setState(() {
          _reminder.dailyTarget = target;
        });
      }
    }
  }

  void _updateInterval({int hours = 0, int minutes = 0, int seconds = 0}) {
    setState(() {
      _reminder.setReminderInterval(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text('Daily Target (glasses)'),
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    errorText: _isValidTarget(_targetController.text) ? null : '',
                  ),
                  controller: _targetController,
                  onChanged: _updateDailyTarget,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Reminder Interval:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Hours',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                    controller: _hoursController,
                    onChanged: (value) {
                      _updateInterval(
                        hours: int.tryParse(value) ?? 0,
                        minutes: int.tryParse(_minutesController.text) ?? 0,
                        seconds: int.tryParse(_secondsController.text) ?? 0,
                      );
                    },
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Min',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                    controller: _minutesController,
                    onChanged: (value) {
                      _updateInterval(
                        hours: int.tryParse(_hoursController.text) ?? 0,
                        minutes: int.tryParse(value) ?? 0,
                        seconds: int.tryParse(_secondsController.text) ?? 0,
                      );
                    },
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Sec',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                    controller: _secondsController,
                    onChanged: (value) {
                      _updateInterval(
                        hours: int.tryParse(_hoursController.text) ?? 0,
                        minutes: int.tryParse(_minutesController.text) ?? 0,
                        seconds: int.tryParse(value) ?? 0,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Progress: ${_reminder.glassCount} / ${_reminder.dailyTarget} glasses',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _reminder.reset();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Count'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _drinkWater,
        tooltip: 'Log water glass',
        child: const Icon(Icons.local_drink),
      ),
    );
  }
}
