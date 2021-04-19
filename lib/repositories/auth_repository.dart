import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_exception.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInWithGoogle();
  User? getCurrentUser();
  Future<void> signOut();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read);
});

class AuthRepository implements BaseAuthRepository {
  final Reader _read;

  AuthRepository(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleSignIn = _read(googleSignInProvider);

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw CustomException(message: 'Login dibatalkan');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _read(firebaseAuthProvider).signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw CustomException(message: error.message);
    } catch (_) {
      throw CustomException(message: 'Login dibatalkan');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _read(googleSignInProvider).disconnect();
      await _read(firebaseAuthProvider).signOut();
    } on FirebaseAuthException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
