import 'package:flutter/material.dart';

class AnimalIntroScreen extends StatelessWidget {
  const AnimalIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              'Mèo',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const Icon(Icons.pets, size: 48),

            Image.network(
              'https://images.unsplash.com/'
              'photo-1514888286974-6c03e2ca1dba?w=800',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const Card(
              child: ListTile(
                title: Text('Thông tin'),
                subtitle: Text('Mèo nhà, thân thiện và đáng yêu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
