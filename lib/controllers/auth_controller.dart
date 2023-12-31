import 'package:erazor/common/snackbar.dart';
import 'package:erazor/repositories/auth_repository.dart';
import 'package:erazor/ui/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  //final Ref _ref;
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository,
        //_ref = ref,
        super(false); // loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, 'Some error occurred!'),
      (r) {
        showSnackBar(context, 'Login successful!');
      },
    );
  }

  void logout() async {
    _authRepository.logOut();
  }
}
