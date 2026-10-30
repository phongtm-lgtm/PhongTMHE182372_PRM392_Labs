import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class LocalTextStorage {
  Future<String?> read(String fileName);
  Future<void> write(String fileName, String text);
}

LocalTextStorage createStorage() => DeviceStorage();

class DeviceStorage implements LocalTextStorage {
  Future<File> _file(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}${Platform.pathSeparator}$fileName');
  }

  @override
  Future<String?> read(String fileName) async {
    final file = await _file(fileName);
    if (!await file.exists()) {
      await file.writeAsString('[]', flush: true);
      return '[]';
    }
    return file.readAsString();
  }

  @override
  Future<void> write(String fileName, String text) async {
    final file = await _file(fileName);
    await file.writeAsString(text, flush: true);
  }
}
