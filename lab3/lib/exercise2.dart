// ignore_for_file: avoid_print

import 'dart:convert';

class User {
  const User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'] as String, email: json['email'] as String);
  }

  final String name;
  final String email;

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  Future<List<User>> getAll() async {
    // This JSON string represents a response received from an API.
    const response = '''
      [
        {"name": "Alice", "email": "alice@example.com"},
        {"name": "Bob", "email": "bob@example.com"}
      ]
    ''';

    await Future<void>.delayed(const Duration(milliseconds: 100));
    final decoded = jsonDecode(response) as List<dynamic>;
    return decoded
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

Future<void> runExercise2() async {
  print('=== Exercise 2: User Repository with JSON ===');
  final users = await UserRepository().getAll();
  for (final user in users) {
    print(user);
  }
  print('');
}

Future<void> main() => runExercise2();
