class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  UserModel({required this.id, required this.name, required this.email, required this.avatarUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'no-email@example.com',
      avatarUrl: json['avatarUrl'] ?? '',
    );

}
