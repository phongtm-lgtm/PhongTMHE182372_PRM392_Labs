// ignore_for_file: avoid_print

import 'dart:async';

Future<void> runExercise3() async {
  print('=== Exercise 3: Async + Microtask Debugging ===');
  final eventFinished = Completer<void>();

  print('1. Synchronous start');
  scheduleMicrotask(() => print('3. Microtask'));
  Future<void>(() {
    print('4. Future event');
    eventFinished.complete();
  });
  print('2. Synchronous end');

  await eventFinished.future;
  // Microtasks are drained before callbacks in the event queue.
  print('Microtasks run before callbacks waiting in the event queue.');
  print('');
}

Future<void> main() => runExercise3();
