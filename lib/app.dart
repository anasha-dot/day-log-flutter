import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/environment.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'state/auth_providers.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = EnvironmentConfig.environment;
    final auth = ref.watch(authStateProvider);
    return MaterialApp(
      title: 'Daylog - ${env.name}',
      home: auth.when(
        data: (user) => user == null ? const LoginScreen() : const HomeScreen(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          body: Center(child: Text('Error: $e')),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
