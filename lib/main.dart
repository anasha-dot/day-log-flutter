import 'package:flutter/material.dart';
import 'timeline_screen.dart';

void main() {
  runApp(const DayLogApp());
}

class DayLogApp extends StatelessWidget {
  const DayLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day Log',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimelineScreen(),
    );
  }
}
