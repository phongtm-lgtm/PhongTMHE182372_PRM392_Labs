import 'dart:convert';

import '../models/item.dart';
import 'storage_platform.dart' as platform;

/// An injectable interface so persistence can be tested without device storage.
abstract class ItemStore {
  Future<List<Item>> read(String fileName);
  Future<void> write(String fileName, List<Item> items);
}

class JsonFileStore implements ItemStore {
  JsonFileStore({platform.LocalTextStorage? storage})
    : _storage = storage ?? platform.createStorage();

  final platform.LocalTextStorage _storage;

  @override
  Future<List<Item>> read(String fileName) async {
    final text = await _storage.read(fileName);
    if (text == null) return [];
    return decodeItems(text);
  }

  @override
  Future<void> write(String fileName, List<Item> items) => _storage.write(
    fileName,
    jsonEncode(items.map((item) => item.toJson()).toList()),
  );
}

List<Item> decodeItems(String text) {
  final value = jsonDecode(text);
  if (value is! List) throw const FormatException('Expected a JSON list');
  return value
      .map((entry) => Item.fromJson(Map<String, dynamic>.from(entry as Map)))
      .toList();
}
