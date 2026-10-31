import 'package:flutter/material.dart';

import 'services/auth_service.dart';
import 'services/google_auth.dart';
import 'services/notifications.dart';
import 'services/session_store.dart';

enum LabMode { mock, api, session, google, notification, full }

class LabApp extends StatefulWidget {
  const LabApp({super.key, required this.mode, this.auth, this.session});
  final LabMode mode;
  final AuthService? auth;
  final SessionStore? session;

  @override
  State<LabApp> createState() => _LabAppState();
}

class _LabAppState extends State<LabApp> {
  late final AuthService auth =
      widget.auth ??
      (widget.mode == LabMode.mock ? MockAuthService() : ApiAuthService());
  late final SessionStore session = widget.session ?? SessionStore();
  final google = GoogleAuth();
  final notices = LocalNotices();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  AuthSession? current;
  bool firebaseUser = false;
  bool busy = true;
  bool firebaseReady = false;
  String? firebaseError;

  bool get hasSession =>
      widget.mode == LabMode.session || widget.mode == LabMode.full;
  bool get hasGoogle =>
      widget.mode == LabMode.google || widget.mode == LabMode.full;
  bool get hasNotice =>
      widget.mode == LabMode.notification || widget.mode == LabMode.full;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    if (hasGoogle) {
      try {
        await google.initialize();
        firebaseReady = true;
        firebaseUser = google.currentUser != null;
      } catch (_) {
        firebaseError =
            'Firebase is not configured. Follow the README setup instructions.';
      }
    }
    if (hasNotice) {
      try {
        await notices.initialize();
      } catch (_) {
        /* Reported when requested. */
      }
    }
    if (hasSession && !firebaseUser) {
      try {
        final stored = await session.load();
        if (stored != null) current = AuthSession(stored.$1, stored.$2);
      } catch (_) {
        /* Remain signed out if storage cannot be read. */
      }
    }
    if (mounted) setState(() => busy = false);
  }

  void _message(String text) {
    if (mounted) {
      messengerKey.currentState?.showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> _notify(String name) async {
    if (!hasNotice) return;
    try {
      await notices.show('Welcome', 'Signed in as $name');
    } catch (_) {
      _message('Signed in, but notification permission or delivery failed.');
    }
  }

  Future<void> _login(String user, String password) async {
    setState(() => busy = true);
    try {
      final result = await auth.login(user, password);
      if (hasSession) await session.save(result.name, result.token);
      if (!mounted) return;
      setState(() => current = result);
      await _notify(result.name);
    } catch (error) {
      _message(
        error is AuthException
            ? error.message
            : 'Could not save session. Please try again.',
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _googleLogin() async {
    setState(() => busy = true);
    try {
      final user = await google.signIn();
      if (!mounted) return;
      setState(() => firebaseUser = true);
      await _notify(user.displayName ?? user.email ?? 'Google user');
    } catch (_) {
      _message(
        'Google sign-in failed or was cancelled. Check Firebase configuration.',
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _logout() async {
    setState(() => busy = true);
    try {
      if (firebaseUser) await google.signOut();
      if (hasSession) await session.clear();
      if (mounted) {
        setState(() {
          current = null;
          firebaseUser = false;
        });
      }
    } catch (_) {
      _message('Logout failed. Please try again.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Lab 10',
    scaffoldMessengerKey: messengerKey,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: Builder(
      builder: (context) {
        if (busy && current == null && !firebaseUser) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (widget.mode == LabMode.notification) {
          return Scaffold(
            appBar: AppBar(title: const Text('Lab 10.5 • Notifications')),
            body: Center(
              child: FilledButton(
                onPressed: () async {
                  try {
                    await notices.show('Lab 10', 'Local notification works!');
                  } catch (_) {
                    _message(
                      'Could not show notification. Check device permissions.',
                    );
                  }
                },
                child: const Text('Show notification'),
              ),
            ),
          );
        }
        if (current != null || firebaseUser) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome, ${firebaseUser ? (google.currentUser?.displayName ?? google.currentUser?.email ?? 'Google user') : current!.name}',
                  ),
                  if (firebaseUser && google.currentUser?.photoURL != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        google.currentUser!.photoURL!,
                      ),
                    ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: busy ? null : _logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          );
        }
        return _LoginPage(
          mode: widget.mode,
          busy: busy,
          onLogin: _login,
          onGoogle: firebaseReady ? _googleLogin : null,
          firebaseError: firebaseError,
        );
      },
    ),
  );
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({
    required this.mode,
    required this.busy,
    required this.onLogin,
    required this.onGoogle,
    this.firebaseError,
  });
  final LabMode mode;
  final bool busy;
  final Future<void> Function(String, String) onLogin;
  final VoidCallback? onGoogle;
  final String? firebaseError;

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final key = GlobalKey<FormState>();
  final user = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    user.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sign in')),
    body: Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (widget.mode != LabMode.google)
                  Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: user,
                          decoration: InputDecoration(
                            labelText: widget.mode == LabMode.mock
                                ? 'Email'
                                : 'DummyJSON username',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter your username/email';
                            }
                            if (widget.mode == LabMode.mock &&
                                !value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter a password'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: widget.busy
                              ? null
                              : () {
                                  if (key.currentState!.validate()) {
                                    widget.onLogin(
                                      user.text.trim(),
                                      password.text,
                                    );
                                  }
                                },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                if (widget.mode == LabMode.mock)
                  const Text('Demo: student@example.com / password123'),
                if (widget.mode != LabMode.mock &&
                    widget.mode != LabMode.google)
                  const Text('DummyJSON demo: emilys / emilyspass'),
                if (widget.mode == LabMode.google ||
                    widget.mode == LabMode.full) ...[
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: widget.busy ? null : widget.onGoogle,
                    child: const Text('Sign in with Google'),
                  ),
                  if (widget.firebaseError != null)
                    Text(widget.firebaseError!, textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
