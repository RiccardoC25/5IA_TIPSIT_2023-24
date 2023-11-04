import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerApp(),
    );
  }
}

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  late Stream<int> tickStream;
  StreamSubscription<int>? tickSubscription;
  int seconds = 0;
  int initialSeconds = 0;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    createTickStream();
  }

  void createTickStream() {
    tickStream = Stream<int>.periodic(Duration(seconds: 1), (x) => x).asyncMap((x) async {
      await Future.delayed(Duration.zero);
      return x + 1;
    });
  }

  void startTimer() {
    if (tickSubscription == null) {
      tickSubscription = tickStream.listen((int tick) {
        if (isRunning) {
          setState(() {
            seconds = initialSeconds + tick;
          });
        }
      });
    }
    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
    });
    tickSubscription?.cancel();
    tickSubscription = null;
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      initialSeconds = 0;
      seconds = 0;
    });
    tickSubscription?.cancel();
    tickSubscription = null;
    createTickStream();
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$hours:$minutes:$remainingSeconds';
  }

  @override
  void dispose() {
    tickSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronometro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tempo trascorso: ${formatTime(seconds)}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isRunning) {
                  stopTimer();
                } else {
                  initialSeconds = seconds;
                  createTickStream();
                  startTimer();
                }
              },
              child: Text(isRunning ? 'Ferma' : 'Avvia'),
            ),
            ElevatedButton(
              onPressed: resetTimer,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
