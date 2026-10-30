abstract class LocalTextStorage {
  Future<String?> read(String fileName);
  Future<void> write(String fileName, String text);
}

LocalTextStorage createStorage() => UnsupportedStorage();

class UnsupportedStorage implements LocalTextStorage {
  @override
  Future<String?> read(String fileName) => Future.error(
    UnsupportedError('Device file storage is not available on web/DartPad.'),
  );

  @override
  Future<void> write(String fileName, String text) => Future.error(
    UnsupportedError('Device file storage is not available on web/DartPad.'),
  );
}
