import 'package:flutter_test/flutter_test.dart';
import 'package:in_class_lab1_6/models/user.dart';

void main() {
  group('User.fromJson', () {
    test('creates a user from complete JSON data', () {
      final user = User.fromJson({
        'id': 1,
        'name': 'Nam',
        'email': 'nam@fpt.edu.vn',
      });

      expect(user.id, 1);
      expect(user.name, 'Nam');
      expect(user.email, 'nam@fpt.edu.vn');
    });

    test('uses the default name and accepts a null email', () {
      final user = User.fromJson({'id': 2, 'name': null, 'email': null});

      expect(user.id, 2);
      expect(user.name, 'Khách');
      expect(user.email, isNull);
    });
  });
}
