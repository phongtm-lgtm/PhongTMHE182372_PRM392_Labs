import 'package:flutter/material.dart';

import 'services/auth_service.dart';

class SimpleApp extends StatefulWidget {
  const SimpleApp({super.key, required this.auth, this.session});
  final AuthService auth;
  final SessionStore? session;

  @override
  State<SimpleApp> createState() => _SimpleAppState();
}

abstract class SessionStore {
  Future<AuthSession?> load();
  Future<void> save(AuthSession session);
  Future<void> clear();
}

class _SimpleAppState extends State<SimpleApp> {
  AuthSession? current;
  bool busy = true;
  String? error;
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    try {
      current = await widget.session?.load();
    } catch (_) {
      error = 'Could not load saved session.';
    }
    if (mounted) setState(() => busy = false);
  }

  Future<void> _login() async {
    if (!formKey.currentState!.validate()) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final result = await widget.auth.login(
        username.text.trim(),
        password.text,
      );
      await widget.session?.save(result);
      if (mounted) setState(() => current = result);
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is AuthException
              ? e.message
              : 'Could not save session.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _logout() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.session?.clear();
      if (mounted) setState(() => current = null);
    } catch (_) {
      if (mounted) setState(() => error = 'Could not log out. Try again.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Lab 10',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: Scaffold(
      appBar: AppBar(title: Text(current == null ? 'Sign in' : 'Home')),
      body: Center(
        child: busy && current == null
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (current == null)
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: username,
                                  decoration: InputDecoration(
                                    labelText: widget.auth is MockAuthService
                                        ? 'Email'
                                        : 'DummyJSON username',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Enter your username/email';
                                    }
                                    if (widget.auth is MockAuthService &&
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
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Enter a password'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                FilledButton(
                                  onPressed: busy ? null : _login,
                                  child: const Text('Login'),
                                ),
                                Text(
                                  widget.auth is MockAuthService
                                      ? 'Demo: student@example.com / password123'
                                      : 'DummyJSON demo: emilys / emilyspass',
                                ),
                              ],
                            ),
                          )
                        else ...[
                          Text('Welcome, ${current!.name}'),
                          FilledButton(
                            onPressed: busy ? null : _logout,
                            child: const Text('Logout'),
                          ),
                        ],
                        if (error != null)
                          Text(
                            error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        if (busy && current != null)
                          const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    ),
  );
}

