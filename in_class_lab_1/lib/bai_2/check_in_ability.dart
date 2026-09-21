import 'employee.dart';

mixin CheckInAbility on Employee {
  void checkIn() {
    print('$name đã điểm danh');
  }
}
