import 'package:flutter/material.dart';

class AnimalHomeScreen extends StatelessWidget {
  const AnimalHomeScreen({super.key});

  static const animals = ['Mèo', 'Chó', 'Thỏ', 'Chim', 'Cá', 'Rùa', 'Hamster'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thế giới động vật',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.pets),
                  SizedBox(width: 8),
                  Text('Các con vật quen thuộc'),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: animals.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.pets),
                        title: Text(animals[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
