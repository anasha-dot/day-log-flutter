import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'config/environment.dart';

Future<void> mainCommon(AppEnvironment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EnvironmentConfig.initialize(env);
  runApp(const ProviderScope(child: MyApp()));
}
