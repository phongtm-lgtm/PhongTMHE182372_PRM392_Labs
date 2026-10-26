import 'package:flutter/material.dart';
import 'package:lab4/ex1/core_widgets_demo.dart';
import 'package:lab4/ex2/input_controls_demo.dart';
import 'package:lab4/ex3/animal_home_screen.dart';
import 'package:lab4/ex4/animal_counter_screen.dart';
import 'package:lab4/ex5/ui_fixes_screen.dart';

void main() {
  runApp(const LabApp());
}

class LabApp extends StatefulWidget {
  const LabApp({super.key});

  @override
  State<LabApp> createState() => _LabAppState();
}

class _LabAppState extends State<LabApp> {
  bool _darkMode = false;

  void _changeTheme(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: _LabMenuScreen(onThemeChanged: _changeTheme),
    );
  }
}

class _LabMenuScreen extends StatelessWidget {
  const _LabMenuScreen({required this.onThemeChanged});

  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const AnimalIntroScreen(),
      const InputControlsDemo(),
      const AnimalHomeScreen(),
      AnimalCounterScreen(onThemeChanged: onThemeChanged),
      const UiFixesScreen(),
    ];
    const titles = [
      'Ex1 - Core Widgets Demo',
      'Ex2 - Input Controls Demo',
      'Ex3 - Layout Demo',
      'Ex4 - App Structure & Theme',
      'Ex5 - Common UI',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lab 4')),
      body: ListView.builder(
        itemCount: screens.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(titles[index]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => screens[index]),
              );
            },
          );
        },
      ),
    );
  }
}
