import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e, st) {
      print('AUTH UNKNOWN ERROR: $e');
      print('STACKTRACE: $st');
      return 'Try again: $e';
    }
  }


  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return 'Cancelled.';

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('GOOGLE AUTH ERROR code=${e.code} message=${e.message}');
      return _getErrorMessage(e.code);
    } catch (e, st) {
      debugPrint('GOOGLE UNKNOWN ERROR: $e');
      debugPrint('$st');
      return 'Try again: $e';
    }
  }



  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (_) {
      return 'Try again';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password is too weak. It must be at least 6 characters.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      default:
        return 'An error occurred: $code';
    }
  }
}
