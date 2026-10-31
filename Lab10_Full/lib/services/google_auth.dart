import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  bool ready = false;

  Future<void> initialize() async {
    await Firebase.initializeApp();
    await GoogleSignIn.instance.initialize();
    ready = true;
  }

  User? get currentUser => ready ? FirebaseAuth.instance.currentUser : null;

  Future<User> signIn() async {
    if (!ready) throw StateError('Firebase is not configured. See README.');
    final googleUser = await GoogleSignIn.instance.authenticate();
    final credential = GoogleAuthProvider.credential(
      idToken: googleUser.authentication.idToken,
    );
    final result = await FirebaseAuth.instance.signInWithCredential(credential);
    if (result.user == null) {
      throw StateError('Google sign-in returned no user.');
    }
    return result.user!;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }
}
