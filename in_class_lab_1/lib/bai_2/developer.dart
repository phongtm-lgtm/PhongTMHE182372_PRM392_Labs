import 'check_in_ability.dart';
import 'employee.dart';

class Developer extends Employee with CheckInAbility {
  Developer(String name) : super(name);

  @override
  void work() => print('$name đang viết code.');
}
