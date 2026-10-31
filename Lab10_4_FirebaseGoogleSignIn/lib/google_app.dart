import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleApp extends StatefulWidget {
  const GoogleApp({super.key});
  @override
  State<GoogleApp> createState() => _GoogleAppState();
}

class _GoogleAppState extends State<GoogleApp> {
  User? user;
  bool busy = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await Firebase.initializeApp();
      await GoogleSignIn.instance.initialize();
      user = FirebaseAuth.instance.currentUser;
    } catch (_) {
      error = 'Firebase not configured. See README (FlutterFire CLI, SHA, Google provider).';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _login() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );
      final result = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      if (mounted) setState(() => user = result.user);
    } catch (_) {
      if (mounted) {
        setState(
          () =>
              error = 'Sign-in failed or was cancelled. Check Firebase setup.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _logout() async {
    setState(() => busy = true);
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();
      if (mounted) setState(() => user = null);
    } catch (_) {
      if (mounted) setState(() => error = 'Sign-out failed.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Lab 10.4 • Google Sign-In')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (busy) const CircularProgressIndicator(),
            if (error != null) Text(error!, textAlign: TextAlign.center),
            if (!busy && user == null && error == null)
              FilledButton(
                onPressed: _login,
                child: const Text('Sign in with Google'),
              ),
            if (user != null) ...[
              if (user!.photoURL != null)
                CircleAvatar(backgroundImage: NetworkImage(user!.photoURL!)),
              Text(user!.displayName ?? user!.email ?? 'Google user'),
              Text(user!.email ?? ''),
              FilledButton(
                onPressed: busy ? null : _logout,
                child: const Text('Logout'),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
