import 'package:flutter/material.dart';

class AnimalCounterScreen extends StatefulWidget {
  const AnimalCounterScreen({
    super.key,
    required this.onThemeChanged,
  });

  final ValueChanged<bool> onThemeChanged;

  @override
  State<AnimalCounterScreen> createState() => _AnimalCounterScreenState();
}

class _AnimalCounterScreenState extends State<AnimalCounterScreen> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đếm con vật')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: widget.onThemeChanged,
          ),
          Expanded(
            child: Center(
              child: Text(
                'Số con vật: $_count',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _count++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
