import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';

class AuthService {
  /// Lazily access FirebaseAuth only when Firebase is initialized.
  FirebaseAuth get _auth {
    if (!firebaseInitialized) {
      throw 'Firebase is not configured. Please set up google-services.json.';
    }
    return FirebaseAuth.instance;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Authentication failed';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Registration failed';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> signOut() async {
    if (firebaseInitialized) {
      await _auth.signOut();
    }
  }

  Stream<User?> get user {
    if (!firebaseInitialized) {
      return const Stream.empty();
    }
    return _auth.authStateChanges();
  }
}
