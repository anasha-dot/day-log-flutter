import 'package:flutter/material.dart';
import 'app.dart';
import 'config/environment.dart';

void mainCommon(AppEnvironment env) {
  EnvironmentConfig.initialize(env);
  runApp(const MyApp());
}
