# Lab 9 — Local JSON Storage

One Flutter project with three tabs:

- **9.1 Assets:** reads `assets/data/items.json` with `rootBundle.loadString`, decodes a list, and shows ID, name and description.
- **9.2 Storage:** adds items in memory; press **Save JSON** to write `lab9_saved_items.json` in the application documents directory. Restart the app to verify it reloads. Unsaved items are intentionally not persisted.
- **9.3 CRUD:** adds, edits (tap an item), deletes (with confirmation), and searches by name or description. Every change is written to `lab9_crud_items.json` before the on-screen list changes. A failed write keeps the previous data.

The two storage tabs use separate files. If a file does not exist, the storage service creates it with `[]`. Data is not reset when the app restarts; uninstalling the app may remove its documents.

## Run

```sh
flutter pub get
flutter run
flutter test
flutter analyze
```

Run on Android/iOS/desktop from Android Studio or VS Code for full persistence. Flutter web/DartPad can demonstrate the asset-reading logic, but `dart:io`/`path_provider` device-file persistence is unavailable there; storage tabs show a clear unsupported message. For DartPad, copy the asset example into Flutter mode and provide the JSON content as a string if asset upload is unavailable. A share link is **not** a substitute for the native persistence deliverable.

For submission, zip the project (excluding build caches), include `assets/data/items.json`, and capture screenshots showing the asset list, a saved list after restarting the app, and the CRUD/search screen. To capture the loading state, run on a device with slower file access or instrument a delayed store in a test build.
