import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/json_file_store.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key, required this.store});

  final ItemStore store;

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  static const fileName = 'lab9_saved_items.json';
  final name = TextEditingController();
  final description = TextEditingController();
  List<Item> items = [];
  bool busy = true;
  bool dirty = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final loaded = await widget.store.read(fileName);
      if (mounted) {
        setState(() {
          items = loaded;
          busy = false;
          error = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          busy = false;
          error = 'Cannot read local file. Device file storage is required.';
        });
      }
    }
  }

  void _add() {
    final text = name.text.trim();
    if (text.isEmpty || busy || error != null) return;
    setState(() {
      final nextId =
          items.fold<int>(0, (max, item) => item.id > max ? item.id : max) + 1;
      items = [
        ...items,
        Item(id: nextId, name: text, description: description.text.trim()),
      ];
      dirty = true;
    });
    name.clear();
    description.clear();
  }

  Future<void> _save() async {
    setState(() => busy = true);
    try {
      await widget.store.write(fileName, items);
      if (mounted) {
        setState(() {
          busy = false;
          dirty = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved to device storage')),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => busy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Save failed. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        if (busy) const LinearProgressIndicator(),
        if (error != null)
          Expanded(child: Center(child: Text(error!)))
        else ...[
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: description,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: busy ? null : _add,
                icon: const Icon(Icons.add),
                label: const Text('Add item'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: busy || !dirty ? null : _save,
                child: const Text('Save JSON'),
              ),
            ],
          ),
          if (dirty) const Text('Unsaved changes'),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No saved items yet.'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(items[index].name),
                      subtitle: Text(items[index].description),
                      leading: CircleAvatar(child: Text('${items[index].id}')),
                    ),
                  ),
          ),
        ],
      ],
    ),
  );
}
