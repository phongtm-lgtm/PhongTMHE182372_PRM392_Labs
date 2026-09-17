// ignore_for_file: avoid_print

import 'dart:async';

class Product {
  const Product({required this.id, required this.name, required this.price});

  final int id;
  final String name;
  final double price;

  @override
  String toString() =>
      'Product(id: $id, name: $name, price: '
      '\$${price.toStringAsFixed(2)})';
}

class ProductRepository {
  final List<Product> _products = [
    const Product(id: 1, name: 'Laptop', price: 999.99),
    const Product(id: 2, name: 'Mouse', price: 25.50),
  ];
  final StreamController<Product> _addedController =
      StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {

    await Future<void>.delayed(const Duration(milliseconds: 100));
    return List<Product>.unmodifiable(_products);
  }

  Stream<Product> liveAdded() => _addedController.stream;

  void add(Product product) {
    _products.add(product);
    _addedController.add(product);
  }

  Future<void> close() => _addedController.close();
}

Future<void> runExercise1() async {
  print('=== Exercise 1: Product Model & Repository ===');
  final repository = ProductRepository();

  final products = await repository.getAll();
  for (final product in products) {
    print('Loaded: $product');
  }

  final receivedUpdate = Completer<void>();
  final subscription = repository.liveAdded().listen((product) {
    print('Live update: $product');
    receivedUpdate.complete();
  });

  repository.add(const Product(id: 3, name: 'Keyboard', price: 49.99));
  await receivedUpdate.future;
  await subscription.cancel();
  await repository.close();
  print('');
}

Future<void> main() => runExercise1();
