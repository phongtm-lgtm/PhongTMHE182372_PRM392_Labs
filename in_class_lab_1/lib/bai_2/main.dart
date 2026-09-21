import 'developer.dart';

void main() {
  List<Developer> teamA = [Developer('An'), Developer('Bình')];
  List<Developer> teamB = [Developer('Cường')];

  List<Developer> allStaff = [...teamA, ...teamB];

  for (final employee in allStaff) {
    employee.checkIn();
  }
}
