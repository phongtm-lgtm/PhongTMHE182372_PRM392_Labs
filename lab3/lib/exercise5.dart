// ignore_for_file: avoid_print

class Settings {
  Settings._internal();

  static final Settings _instance = Settings._internal();

  // Every call returns the same cached object instead of creating a new one.
  factory Settings() => _instance;
}

void runExercise5() {
  print('=== Exercise 5: Factory Constructors & Cache ===');
  final settingsA = Settings();
  final settingsB = Settings();

  print('identical(settingsA, settingsB): ${identical(settingsA, settingsB)}');
  // Expected output: true.
}

void main() => runExercise5();
