import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String? username;
  final String? photoUrl;
  final List<String> moods;
  final List<String> interests;

  UserProfile({
    required this.uid,
    required this.email,
    this.username,
    this.photoUrl,
    this.moods = const [],
    this.interests = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
      'moods': moods,
      'interests': interests,
    };
  }

  factory UserProfile.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return UserProfile(
      uid: doc.id,
      email: data?['email'] ?? '',
      username: data?['username'],
      photoUrl: data?['photoUrl'],
      moods: List<String>.from(data?['moods'] ?? []),
      interests: List<String>.from(data?['interests'] ?? []),
    );
  }
}
