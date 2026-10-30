import 'package:flutter/material.dart';

import 'screens/asset_screen.dart';
import 'screens/crud_screen.dart';
import 'screens/storage_screen.dart';
import 'services/json_file_store.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Lab 9 - Local JSON',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const LabHome(),
  );
}

class LabHome extends StatefulWidget {
  const LabHome({super.key});

  @override
  State<LabHome> createState() => _LabHomeState();
}

class _LabHomeState extends State<LabHome> {
  int index = 0;
  final store = JsonFileStore();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(['9.1 • Assets', '9.2 • Save & Load', '9.3 • CRUD'][index]),
    ),
    body: IndexedStack(
      index: index,
      children: [
        const AssetScreen(),
        StorageScreen(store: store),
        CrudScreen(store: store),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.folder_open), label: 'Assets'),
        NavigationDestination(icon: Icon(Icons.save), label: 'Storage'),
        NavigationDestination(icon: Icon(Icons.edit_note), label: 'CRUD'),
      ],
    ),
  );
}
