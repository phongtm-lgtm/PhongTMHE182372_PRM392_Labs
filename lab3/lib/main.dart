import 'exercise1.dart' as exercise1;
import 'exercise2.dart' as exercise2;
import 'exercise3.dart' as exercise3;
import 'exercise4.dart' as exercise4;
import 'exercise5.dart' as exercise5;

Future<void> main() async {
  await exercise1.runExercise1();
  await exercise2.runExercise2();
  await exercise3.runExercise3();
  await exercise4.runExercise4();
  exercise5.runExercise5();
}
