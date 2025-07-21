import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel user) {
    return _users.doc(user.id).set(user.toMap());
  }

  Stream<UserModel> getUser(String id) {
    return _users.doc(id).snapshots().map((s) => UserModel.fromMap(s.data()!));
  }
}
