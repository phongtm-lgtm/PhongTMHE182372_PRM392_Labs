# Lab 10.5 — Local Notification (mandatory LO7)

Run `flutter pub get` and `flutter run` on an Android device/emulator (Android 13+ recommended). Tap **Show notification**, grant notification permission when asked, and check the system notification shade. Android manifest includes `POST_NOTIFICATIONS`; Gradle enables core library desugaring. iOS also requests alert/badge/sound permission when triggered.

No account required. Web does not support this native plugin demonstration. Verify actual system delivery on a device (not in widget tests). Run `flutter analyze` and `flutter test` for code-level checks.
