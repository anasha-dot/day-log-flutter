import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserModel?> get userStream => _auth.authStateChanges().asyncMap(_userFromFirebase);

  Future<UserModel?> _userFromFirebase(User? user) async {
    if (user == null) return null;
    final doc = _db.collection('users').doc(user.uid);
    final snap = await doc.get();
    if (!snap.exists) {
      final newUser = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
      await doc.set(newUser.toMap());
      return newUser;
    }
    return UserModel.fromMap(user.uid, snap.data()!);
  }

  Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCred = await _auth.signInWithCredential(credential);
    return _userFromFirebase(userCred.user);
  }

  Future<UserModel?> registerWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(cred.user);
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(cred.user);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
