class AuthState {
  final bool isPasswordVisible;
  final bool isSignupPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool rememberMe;
  final bool acceptTerms;
  final bool isLoading;

  const AuthState({
    this.isPasswordVisible = false,
    this.isSignupPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.rememberMe = false,
    this.acceptTerms = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isPasswordVisible,
    bool? isSignupPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? rememberMe,
    bool? acceptTerms,
    bool? isLoading,
  }) {
    return AuthState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isSignupPasswordVisible:
          isSignupPasswordVisible ?? this.isSignupPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


