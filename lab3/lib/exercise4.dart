// ignore_for_file: avoid_print

Stream<int> createEvenSquares() {
  final numbers = Stream<int>.fromIterable([1, 2, 3, 4, 5]);
  return numbers
      .map((number) => number * number) // Squares: 1, 4, 9, 16, 25.
      .where((square) => square.isEven); // Keep only 4 and 16.
}

Future<void> runExercise4() async {
  print('=== Exercise 4: Stream Transformation ===');
  await for (final value in createEvenSquares()) {
    print('Even square: $value');
  }
  print('');
}

Future<void> main() => runExercise4();
