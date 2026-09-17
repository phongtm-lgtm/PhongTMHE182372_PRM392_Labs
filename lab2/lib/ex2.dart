void exe2(){

  print('EXE2 start:');
  //List
  List<int> numbers = [10,11,12,23];
  print('After add: $numbers');
  numbers.add(1);
  print('Before add: $numbers');
  numbers.remove(12);
  print("Test remove: $numbers");

  // Operators
  int a = 10;
  int b = 5;

  print('a + b = ${a + b}');
  print('a - b = ${a - b}');
  print('a == b: ${a == b}');
  print('a > 5 && b < 10: ${a > 5 && b < 10}');

  // Ternary operator
  String result = a > b ? 'a is greater' : 'b is greater';
  print(result);

  // Set contains unique values
  Set<int> uniqueNumbers = {1, 2, 2, 3, 3, 4};

  uniqueNumbers.add(5);
  uniqueNumbers.remove(2);

  print('Set: $uniqueNumbers');

  // Map stores key-value pairs
  Map<String, int> scores = {
    'Math': 9,
    'English': 8,
    'Physics': 7,
  };

  print('Scores: $scores');
  print('Math score: ${scores['Math']}');
}