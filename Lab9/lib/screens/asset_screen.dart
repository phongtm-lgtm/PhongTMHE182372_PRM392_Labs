import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/item.dart';
import '../services/json_file_store.dart';

class AssetScreen extends StatefulWidget {
  const AssetScreen({super.key});

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen> {
  late Future<List<Item>> items;

  @override
  void initState() {
    super.initState();
    items = _load();
  }

  Future<List<Item>> _load() async =>
      decodeItems(await rootBundle.loadString('assets/data/items.json'));

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Item>>(
    future: items,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Cannot load asset JSON: ${snapshot.error}'));
      }
      final data = snapshot.data!;
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(child: Text('${data[index].id}')),
          title: Text(data[index].name),
          subtitle: Text(data[index].description),
        ),
      );
    },
  );
}
