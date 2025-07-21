import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  Stream<User?> get authStateChanges => FirebaseService.auth.authStateChanges();

  Future<void> signInAnonymously() async {
    await FirebaseService.auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await FirebaseService.auth.signOut();
  }
}
