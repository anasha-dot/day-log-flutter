import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day Log',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  UserModel? _user;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _auth.userStream.listen((u) {
      setState(() {
        _user = u;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sign In')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _auth.signInWithGoogle,
                child: const Text('Sign In with Google'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signInWithEmail('demo@example.com', 'password');
                },
                child: const Text('Sign In with Email'),
              )
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${_user!.displayName ?? _user!.email}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _auth.signOut,
          )
        ],
      ),
      body: const Center(child: Text('Logged In')),
    );
  }
}
