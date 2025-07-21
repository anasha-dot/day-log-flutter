class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  UserModel({required this.uid, this.email, this.displayName, this.photoUrl});

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'] as String?,
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    }..removeWhere((key, value) => value == null);
  }
}
