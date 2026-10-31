# Lab 10.2 — REST API Login

Run `flutter pub get` then `flutter run` on Android with internet access. This project POSTs a username/password to `https://dummyjson.com/auth/login`, parses `accessToken`, handles HTTP failures and network timeouts, then shows Home. Logout returns to Login. The token is not persisted in this part.

DummyJSON demo account: `emilys` / `emilyspass` (check DummyJSON documentation if demo accounts change). Never use a real password with this demo API.

Run `flutter analyze` and `flutter test` (the API test uses a fake HTTP client and does not require internet).
