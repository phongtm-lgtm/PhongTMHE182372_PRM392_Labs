import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab9/models/item.dart';
import 'package:lab9/screens/asset_screen.dart';
import 'package:lab9/screens/crud_screen.dart';
import 'package:lab9/screens/storage_screen.dart';
import 'package:lab9/services/json_file_store.dart';

class MemoryStore implements ItemStore {
  final files = <String, List<Item>>{};
  bool failWrite = false;

  @override
  Future<List<Item>> read(String fileName) async =>
      List.of(files[fileName] ?? []);

  @override
  Future<void> write(String fileName, List<Item> items) async {
    if (failWrite) throw Exception('Disk full');
    files[fileName] = List.of(items);
  }
}

void main() {
  testWidgets('Lab 9.1 reads embedded JSON asset', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: AssetScreen())));
    await tester.pumpAndSettle();
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('Build apps for multiple platforms'), findsOneWidget);
  });

  test('JSON model round-trip and invalid data', () {
    final parsed = decodeItems(
      '[{"id":1,"name":"Dart","description":"Language"}]',
    );
    expect(parsed.single.toJson(), {
      'id': 1,
      'name': 'Dart',
      'description': 'Language',
    });
    expect(() => decodeItems('{}'), throwsFormatException);
  });

  testWidgets('Lab 9.2 saves items and reloads from storage', (tester) async {
    final store = MemoryStore();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: StorageScreen(store: store)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Notebook');
    await tester.enterText(find.byType(TextField).last, 'For notes');
    await tester.tap(find.text('Add item'));
    await tester.pump();
    await tester.tap(find.text('Save JSON'));
    await tester.pumpAndSettle();
    expect(store.files['lab9_saved_items.json']!.single.name, 'Notebook');
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: StorageScreen(store: store)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Notebook'), findsOneWidget);
  });

  testWidgets('Lab 9.3 CRUD saves, searches, and rejects failed writes', (
    tester,
  ) async {
    final store = MemoryStore();
    await tester.pumpWidget(MaterialApp(home: CrudScreen(store: store)));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add item'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Dart');
    await tester.enterText(
      find.widgetWithText(TextField, 'Description'),
      'Language',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(store.files['lab9_crud_items.json']!.single.name, 'Dart');
    await tester.enterText(find.byType(TextField).first, 'missing');
    await tester.pumpAndSettle();
    expect(find.text('No matching items.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'dart');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dart'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Flutter');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(store.files['lab9_crud_items.json']!.single.name, 'Flutter');
    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    store.failWrite = true;
    await tester.tap(find.byTooltip('Delete Flutter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Flutter'), findsOneWidget);
    store.failWrite = false;
    await tester.tap(find.byTooltip('Delete Flutter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(store.files['lab9_crud_items.json'], isEmpty);
  });
}
