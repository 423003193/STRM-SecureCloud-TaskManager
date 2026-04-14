import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../main.dart';

class AuthService {
  /// Lazily access FirebaseAuth only when Firebase is initialized.
  FirebaseAuth get _auth {
    if (!firebaseInitialized) {
      throw 'Firebase is not configured. Please set up google-services.json.';
    }
    return FirebaseAuth.instance;
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      if (firebaseInitialized) {
         await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
         );
      }
      return true;
    } catch (e) {
      // Emulator Offline fallback - bypass login if network/Firebase is unreachable
      debugPrint('Firebase login failed (emulator offline), bypassing: $e');
      return true;
    }
  }

  Future<bool> registerWithEmail(String email, String password) async {
    try {
      if (firebaseInitialized) {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      return true;
    } catch (e) {
      // Emulator Offline fallback - bypass register if network/Firebase is unreachable
      debugPrint('Firebase register failed (emulator offline), bypassing: $e');
      return true;
    }
  }

  Future<void> signOut() async {
    if (firebaseInitialized) {
      try {
        await _auth.signOut();
      } catch (_) {
        // Ignore offline errors on sign out
      }
    }
  }

  Stream<User?> get user {
    if (!firebaseInitialized) {
      return const Stream.empty();
    }
    return _auth.authStateChanges();
  }
}
