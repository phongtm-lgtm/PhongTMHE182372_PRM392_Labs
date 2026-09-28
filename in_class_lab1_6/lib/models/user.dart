class User {
  final int id;
  final String name;
  final String? email;

  const User({required this.id, required this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Khách',
      email: json['email'] as String?,
    );
  }

  void showProfile() {
    print('ID: $id | Tên: $name | Email: ${email ?? 'Chưa cập nhật'}');
  }
}
