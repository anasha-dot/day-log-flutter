import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/diary_entry.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _tagController = TextEditingController();
  EntryVisibility _visibility = EntryVisibility.private;
  File? _mediaFile;

  @override
  void dispose() {
    _textController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _mediaFile = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await Firebase.initializeApp();
    String? mediaUrl;
    if (_mediaFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('entry_media')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      await storageRef.putFile(_mediaFile!);
      mediaUrl = await storageRef.getDownloadURL();
    }

    final doc = await FirebaseFirestore.instance.collection('entries').add({
      'text': _textController.text,
      'tag': _tagController.text,
      'visibility': _visibility.name,
      'mediaUrl': mediaUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Entry ${doc.id} saved')));
    _formKey.currentState!.reset();
    setState(() {
      _mediaFile = null;
      _visibility = EntryVisibility.private;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Entry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Text'),
                validator: (v) => v == null || v.isEmpty ? 'Enter text' : null,
                maxLines: 4,
              ),
              TextFormField(
                controller: _tagController,
                decoration: const InputDecoration(labelText: 'Tag'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<EntryVisibility>(
                value: _visibility,
                decoration: const InputDecoration(labelText: 'Visibility'),
                items: EntryVisibility.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      _visibility = v;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              if (_mediaFile != null)
                Image.file(_mediaFile!, height: 150),
              TextButton.icon(
                onPressed: _pickMedia,
                icon: const Icon(Icons.photo),
                label: Text(_mediaFile == null ? 'Add Media' : 'Change Media'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
