void exe3(){
// 1. If/else - check score
  int score = 8;

  if (score >= 8) {
    print('Good');
  } else if (score >= 5) {
    print('Passed');
  } else {
    print('Failed');
  }

  // 2. Switch - check day of week
  int day = 2;

  switch (day) {
    case 1:
      print('Monday');
    case 2:
      print('Tuesday');
    case 3:
      print('Wednesday');
    case 4:
      print('Thursday');
    case 5:
      print('Friday');
    case 6:
      print('Saturday');
    case 7:
      print('Sunday');
    default:
      print('Invalid day');
  }

  // 3. Loop through a collection
  List<int> numbers = [10, 20, 30, 40, 50];

  // Normal for loop
  print('--- For loop ---');
  for (int i = 0; i < numbers.length; i++) {
    print(numbers[i]);
  }

  // For-in loop
  print('--- For-in loop ---');
  for (int number in numbers) {
    print(number);
  }

  // forEach
  print('--- forEach ---');
  numbers.forEach((number) {
    print(number);
  });

  // 4. Call normal function
  int sum = add(10, 20);
  print('10 + 20 = $sum');

  // Call arrow function
  int result = mul(10, 2);
  print('10 * 2 = $result');
}

// Normal function
int add(int a, int b) {
  return a + b;
}

// Arrow function
int mul(int a, int b) => a * b;
