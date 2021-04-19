import 'dart:async';

import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:bukutugas/repositories/auth_repository.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.read);
});

final userProvider = Provider<User?>((ref) {
  final user = ref.watch(authProvider).data?.value;

  ref.read(firebaseAnalyticsProvider).setUserId(user?.uid);

  return user;
});

final authExceptionProvider = StateProvider<CustomException?>((_) => null);

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthNotifier(this._read)
      : super(AsyncValue.data(_read(authRepositoryProvider).getCurrentUser())) {
    _authStateChangesSubscription?.cancel();

    _authStateChangesSubscription =
        _read(authRepositoryProvider).authStateChanges.listen(
      (user) {
        state = AsyncValue.data(user);
      },
    );
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  void signInWithGoogle() async {
    try {
      if (state.data?.value == null) {
        state = AsyncValue.loading();

        await _read(authRepositoryProvider).signInWithGoogle();
      }
    } on CustomException catch (error) {
      state = AsyncValue.data(null);
      _read(authExceptionProvider).state = error;
    }
  }

  void signOut() async {
    try {
      state = AsyncValue.loading();

      await _read(authRepositoryProvider).signOut();
    } on CustomException catch (error) {
      _read(authExceptionProvider).state = error;
    }
  }
}
