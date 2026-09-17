import 'package:flutter_test/flutter_test.dart';
import 'package:lab3/exercise1.dart';
import 'package:lab3/exercise2.dart';
import 'package:lab3/exercise4.dart';
import 'package:lab3/exercise5.dart';

void main() {
  test('ProductRepository returns and emits products', () async {
    final repository = ProductRepository();
    final addedProduct = const Product(id: 3, name: 'Keyboard', price: 49.99);

    expect(await repository.getAll(), hasLength(2));
    expectLater(repository.liveAdded(), emits(addedProduct));
    repository.add(addedProduct);

    await repository.close();
  });

  test('UserRepository parses users from JSON', () async {
    final users = await UserRepository().getAll();

    expect(users, hasLength(2));
    expect(users.first.name, 'Alice');
    expect(users.first.email, 'alice@example.com');
  });

  test('stream transformation returns even squares', () async {
    final values = await createEvenSquares().toList();

    expect(values, [4, 16]);
  });

  test('Settings factory returns one cached instance', () {
    expect(identical(Settings(), Settings()), isTrue);
  });
}
