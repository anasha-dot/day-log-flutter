import 'package:flutter/material.dart';
import 'config/environment.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final env = EnvironmentConfig.environment;
    return MaterialApp(
      title: 'Daylog',
      home: Scaffold(
        appBar: AppBar(title: const Text('Daylog')),
        body: Center(
          child: Text('Running in ' + env.name + ' mode'),
        ),
      ),
    );
  }
}
