import 'package:in_class_lab1_6/models/user.dart';

void main() {
  final rawData1 = <String, dynamic>{
    'id': 1,
    'name': 'Nam',
    'email': 'nam@fpt.edu.vn',
  };
  final rawData2 = <String, dynamic>{'id': 2, 'name': null, 'email': null};

  final user1 = User.fromJson(rawData1);
  final user2 = User.fromJson(rawData2);

  user1.showProfile();
  user2.showProfile();
}
