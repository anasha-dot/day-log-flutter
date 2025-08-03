import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final profile = ref.watch(userProfileProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${profile?.username ?? user?.email ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Center(
        child: profile == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (profile.photoUrl != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(profile.photoUrl!),
                      radius: 40,
                    ),
                  const SizedBox(height: 16),
                  Text('Moods: ${profile.moods.join(', ')}'),
                  Text('Interests: ${profile.interests.join(', ')}'),
                ],
              ),
      ),
    );
  }
}
