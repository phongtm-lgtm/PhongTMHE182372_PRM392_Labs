// Async function returning a Future
Future<String> loadData() async {
  print('Loading data...');

  // Simulate waiting for data
  await Future.delayed(Duration(seconds: 2));

  return 'Data loaded successfully';
}

Future<void> exe5() async {
  // Future + async/await
  String result = await loadData();
  print(result);

  // Null Safety

  // ? allows the variable to contain null
  String? name;

  // ?? provides a default value when name is null
  print(name ?? 'Unknown');

  name = 'Long';

  // ! tells Dart that name is definitely not null
  print(name!.length);

  // Stream

  Stream<int> numberStream = Stream.fromIterable([
    1,
    2,
    3,
    4,
    5,
  ]);

  // Listen to values emitted by the stream
  numberStream.listen((number) {
    print('Stream value: $number');
  });
}