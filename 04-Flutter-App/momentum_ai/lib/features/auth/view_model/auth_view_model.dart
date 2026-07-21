import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/auth_state.dart';
import '../../../core/services/api_service.dart';
// 🔥 Import Dashboard ViewModel add kiya (Cache reset ke liye zaroori hai)
import '../../../features/dashboard/view_model/dashboard_view_model.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleSignupPasswordVisibility() {
    state = state.copyWith(
      isSignupPasswordVisible: !state.isSignupPasswordVisible,
    );
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  void toggleAcceptTerms() {
    state = state.copyWith(acceptTerms: !state.acceptTerms);
  }

  // --- REAL API LOGIC ---

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ApiService.login(email, password);

      // Save Token & User Data automatically
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      await prefs.setString('userId', response['id']?.toString() ?? '');
      await prefs.setString('userName', response['name'] ?? '');
      await prefs.setString('userEmail', response['email'] ?? '');

      // 🔥 FIX: Dashboard ViewModel ko invalidate (reset) karein
      // Taake naye user ka data backend se dobara fetch ho, aur purana naam na dikhe
      ref.invalidate(dashboardViewModelProvider);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ApiService.signup(
        fullName: fullName,
        email: email,
        password: password,
      );

      // Auto Login after Signup (Save token)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      await prefs.setString('userId', response['id']?.toString() ?? '');
      await prefs.setString('userName', response['name'] ?? '');
      await prefs.setString('userEmail', response['email'] ?? '');

      // 🔥 FIX: Signup ke baad bhi Dashboard ViewModel invalidate karein
      ref.invalidate(dashboardViewModelProvider);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signInWithGoogle() async {
    // Future logic for Google Auth goes here
  }

  Future<void> signInWithApple() async {
    // Future logic for Apple Auth goes here
  }
}
