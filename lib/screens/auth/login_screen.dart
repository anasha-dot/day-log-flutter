import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/auth_providers.dart';
import 'signup_screen.dart';
import 'password_reset_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () => ref
                      .read(authControllerProvider.notifier)
                      .signInWithEmail(
                        _emailController.text,
                        _passwordController.text,
                      ),
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              ),
              child: const Text('Create account'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PasswordResetScreen()),
              ),
              child: const Text('Forgot password?'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () => ref
                  .read(authControllerProvider.notifier)
                  .signInWithGoogle(),
              child: const Text('Sign in with Google'),
            ),
            ElevatedButton(
              onPressed: () => ref
                  .read(authControllerProvider.notifier)
                  .signInWithApple(),
              child: const Text('Sign in with Apple'),
            ),
            ElevatedButton(
              onPressed: () => ref
                  .read(authControllerProvider.notifier)
                  .signInWithFacebook(),
              child: const Text('Sign in with Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
