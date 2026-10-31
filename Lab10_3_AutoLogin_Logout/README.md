# Lab 10.3 — Auto Login & Logout

Run `flutter pub get` then `flutter run` on Android with internet access. Splash/loading restores a DummyJSON access token from `SharedPreferences` and routes to Home if one exists. Logout removes that token and returns to Login. Restart the app after signing in to verify restoration.

DummyJSON demo account: `emilys` / `emilyspass`. The lab checks for a saved token, **not** server-side validity or expiry; SharedPreferences is not secure storage for production credentials.

Run `flutter analyze` and `flutter test`.
