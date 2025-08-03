import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_profile.dart';
import '../../state/auth_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _usernameController = TextEditingController();
  File? _image;
  final List<String> _selectedMoods = [];
  final List<String> _selectedInterests = [];

  final _moods = const ['Happy', 'Sad', 'Excited', 'Calm'];
  final _interests = const ['Music', 'Sports', 'Art', 'Travel'];

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(String uid) async {
    if (_image == null) return null;
    final ref = FirebaseStorage.instance.ref('profilePictures/$uid.jpg');
    await ref.putFile(_image!);
    return await ref.getDownloadURL();
  }

  Future<void> _complete() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final photoUrl = await _uploadImage(user.uid);
    final profile = UserProfile(
      uid: user.uid,
      email: user.email ?? '',
      username: _usernameController.text,
      photoUrl: photoUrl,
      moods: _selectedMoods,
      interests: _selectedInterests,
    );
    await ref.read(authServiceProvider).createUserProfile(profile);
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set up your profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.camera_alt, size: 32)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select moods'),
            Wrap(
              spacing: 8,
              children: _moods.map((m) {
                final selected = _selectedMoods.contains(m);
                return FilterChip(
                  label: Text(m),
                  selected: selected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedMoods.add(m);
                      } else {
                        _selectedMoods.remove(m);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Select interests'),
            Wrap(
              spacing: 8,
              children: _interests.map((i) {
                final selected = _selectedInterests.contains(i);
                return FilterChip(
                  label: Text(i),
                  selected: selected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedInterests.add(i);
                      } else {
                        _selectedInterests.remove(i);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _complete,
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
