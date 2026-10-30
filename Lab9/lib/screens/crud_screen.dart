import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/json_file_store.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key, required this.store});

  final ItemStore store;

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  static const fileName = 'lab9_crud_items.json';
  List<Item> items = [];
  String query = '';
  String? error;
  bool busy = true;

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
          error =
              'Cannot read local JSON file. Device file storage is required.';
        });
      }
    }
  }

  Future<void> _update(List<Item> next) async {
    setState(() => busy = true);
    try {
      await widget.store.write(fileName, next);
      if (mounted) {
        setState(() {
          items = next;
          busy = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => busy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save changes. Try again.')),
        );
      }
    }
  }

  Future<void> _edit([Item? existing]) async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) => _ItemDialog(existing: existing),
    );
    if (!mounted || result == null) return;
    if (existing == null) {
      final id =
          items.fold<int>(0, (max, item) => item.id > max ? item.id : max) + 1;
      await _update([
        ...items,
        Item(id: id, name: result.$1, description: result.$2),
      ]);
    } else {
      await _update([
        for (final item in items)
          item.id == existing.id
              ? Item(id: item.id, name: result.$1, description: result.$2)
              : item,
      ]);
    }
  }

  Future<void> _delete(Item item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('Delete ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (mounted && confirmed == true) {
      await _update(items.where((entry) => entry.id != item.id).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = items
        .where(
          (item) =>
              item.name.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query),
        )
        .toList();
    return Scaffold(
      body: Column(
        children: [
          if (busy) const LinearProgressIndicator(),
          if (error != null)
            Expanded(child: Center(child: Text(error!)))
          else ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search name or description',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) =>
                    setState(() => query = value.toLowerCase().trim()),
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? Center(
                      child: Text(
                        items.isEmpty
                            ? 'No items yet. Tap + to add one.'
                            : 'No matching items.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final item = visible[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text('${item.id}')),
                          title: Text(item.name),
                          subtitle: Text(item.description),
                          onTap: busy ? null : () => _edit(item),
                          trailing: IconButton(
                            tooltip: 'Delete ${item.name}',
                            onPressed: busy ? null : () => _delete(item),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ],
      ),
      floatingActionButton: error == null
          ? FloatingActionButton(
              onPressed: busy ? null : () => _edit(),
              tooltip: 'Add item',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _ItemDialog extends StatefulWidget {
  const _ItemDialog({this.existing});

  final Item? existing;

  @override
  State<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<_ItemDialog> {
  late final name = TextEditingController(text: widget.existing?.name);
  late final description = TextEditingController(
    text: widget.existing?.description,
  );

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.existing == null ? 'Add item' : 'Edit item'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: description,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (name.text.trim().isNotEmpty) {
            Navigator.pop(context, (name.text.trim(), description.text.trim()));
          }
        },
        child: const Text('Save'),
      ),
    ],
  );
}
