import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 900));

    state = state.copyWith(isLoading: false);
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 900));

    state = state.copyWith(isLoading: false);
  }
}
