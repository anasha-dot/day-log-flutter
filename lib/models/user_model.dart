class UserModel {
  final String id;
  final String? name;

  UserModel({required this.id, this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(id: map['id'] as String, name: map['name'] as String?);
  }
}
