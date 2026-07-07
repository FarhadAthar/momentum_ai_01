class AuthState {
  final bool isPasswordVisible;
  final bool rememberMe;
  final bool isLoading;

  const AuthState({
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isPasswordVisible,
    bool? rememberMe,
    bool? isLoading,
  }) {
    return AuthState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
