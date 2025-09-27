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

  void _drinkWater() {
    setState(() {
      _reminder.drink();
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
            const Text('Number of water glasses today:'),
            Text(
              '${_reminder.glassCount}',
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