import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_assets.dart';
import '../view_model/auth_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _setupSystemBars();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  void _setupSystemBars() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFFFF7EC),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      // ✅ FIX: AuthViewModel ke signIn ko call karein
      await ref
          .read(authViewModelProvider.notifier)
          .signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;
      // ViewModel already saved the token, now go to Dashboard
      context.go(AppRoutes.dashboard);
    } catch (e) {
      if (!mounted) return;
      // ✅ Clean Error Message
      String errorMsg = e.toString().replaceAll('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMsg,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.textDark,
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    await ref.read(authViewModelProvider.notifier).signInWithGoogle();
  }

  Future<void> _handleAppleLogin() async {
    await ref.read(authViewModelProvider.notifier).signInWithApple();
  }

  void _goToSignup() {
    context.go(AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFFFF7EC),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFF7EC),
        body: Stack(
          children: [
            const _PremiumLoginBackground(),
            SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: FocusScope.of(context).unfocus,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
                  child: Column(
                    children: [
                      const _LoginHeader(),
                      const SizedBox(height: 24),
                      _LoginGlassCard(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        emailFocusNode: _emailFocusNode,
                        passwordFocusNode: _passwordFocusNode,
                        isPasswordVisible: authState.isPasswordVisible,
                        rememberMe: authState.rememberMe,
                        isLoading: authState.isLoading,
                        onTogglePassword: ref
                            .read(authViewModelProvider.notifier)
                            .togglePasswordVisibility,
                        onToggleRememberMe: ref
                            .read(authViewModelProvider.notifier)
                            .toggleRememberMe,
                        onLoginTap: _handleLogin,
                        onGoogleTap: _handleGoogleLogin,
                        onAppleTap: _handleAppleLogin,
                      ),
                      const Spacer(),
                      _SignupFooter(onSignupTap: _goToSignup),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          'Sign In',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 37,
            height: 1.0,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.7,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 11),
        Text(
          'Unlock your momentum with AI guidance.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.42,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.12,
            color: AppTheme.textMuted.withValues(alpha: 0.92),
          ),
        ),
      ],
    );
  }
}

class _LoginGlassCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool isPasswordVisible;
  final bool rememberMe;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleRememberMe;
  final VoidCallback onLoginTap;
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  const _LoginGlassCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.isPasswordVisible,
    required this.rememberMe,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onToggleRememberMe,
    required this.onLoginTap,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: Colors.white.withValues(alpha: 0.85),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.82),
              width: 1.15,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withValues(alpha: 0.075),
                blurRadius: 34,
                offset: const Offset(0, 20),
              ),
              BoxShadow(
                color: AppTheme.primaryViolet.withValues(alpha: 0.060),
                blurRadius: 42,
                offset: const Offset(0, 26),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.64),
                blurRadius: 16,
                offset: const Offset(-7, -7),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _FieldLabel(text: 'Email'),
                const SizedBox(height: 8),
                _PremiumTextField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'momentum@ai.com',
                  prefixIcon: Icons.alternate_email_rounded,
                  onSubmitted: (_) => passwordFocusNode.requestFocus(),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                _FieldLabel(text: 'Password'),
                const SizedBox(height: 8),
                _PremiumTextField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !isPasswordVisible,
                  suffixIcon: isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: onTogglePassword,
                  onSubmitted: (_) => onLoginTap(),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 14),
                _RememberForgotRow(
                  rememberMe: rememberMe,
                  onRememberTap: onToggleRememberMe,
                ),
                const SizedBox(height: 32),
                _PrimaryLoginButton(isLoading: isLoading, onTap: onLoginTap),
                const SizedBox(height: 24),
                const _SocialDivider(),
                const SizedBox(height: 20),
                _SocialButtonsRow(
                  isLoading: isLoading,
                  onGoogleTap: onGoogleTap,
                  onAppleTap: onAppleTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.15,
        color: const Color(0xFF253047),
      ),
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  const _PremiumTextField({
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      cursorColor: AppTheme.primaryBlue,
      style: TextStyle(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        color: AppTheme.textDark,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF858B98),
        ),
        prefixIcon: Icon(prefixIcon, size: 23, color: const Color(0xFF747B8C)),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                onPressed: onSuffixTap,
                splashRadius: 20,
                icon: Icon(
                  suffixIcon,
                  size: 23,
                  color: const Color(0xFF747B8C),
                ),
              ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.78),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: const Color(0xFF253047).withValues(alpha: 0.42),
            width: 1.22,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppTheme.primaryBlue,
            width: 1.55,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.22),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.55),
        ),
        errorStyle: TextStyle(
          fontSize: 11.5,
          height: 1.1,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE5484D),
        ),
      ),
    );
  }
}

class _RememberForgotRow extends StatelessWidget {
  final bool rememberMe;
  final VoidCallback onRememberTap;

  const _RememberForgotRow({
    required this.rememberMe,
    required this.onRememberTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onRememberTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: rememberMe
                  ? AppTheme.primaryBlue
                  : const Color(0xFFF2F4FA),
              border: Border.all(
                color: rememberMe
                    ? AppTheme.primaryBlue
                    : const Color(0xFFC8CEDA),
                width: 1.15,
              ),
              boxShadow: rememberMe
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: rememberMe
                ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          'Remember me',
          style: TextStyle(
            fontSize: 13.4,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.1,
            color: const Color(0xFF253047),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(10, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: AppTheme.primaryViolet,
          ),
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 13.4,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.15,
              color: AppTheme.primaryViolet,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryLoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _PrimaryLoginButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(21),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          child: Ink(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppTheme.primaryBlue,
                  Color(0xFF6258FF),
                  AppTheme.primaryViolet,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.20),
                  blurRadius: 22,
                  offset: const Offset(0, 11),
                ),
                BoxShadow(
                  color: AppTheme.primaryViolet.withValues(alpha: 0.16),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: isLoading
                    ? const SizedBox(
                        key: ValueKey('login-loading'),
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Log In',
                        key: const ValueKey('login-text'),
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.25,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialDivider extends StatelessWidget {
  const _SocialDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _DividerLine()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Log in with social account',
            style: TextStyle(
              fontSize: 12.6,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.25,
              color: const Color(0xFF858B98),
            ),
          ),
        ),
        const Expanded(child: _DividerLine()),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0xFFE3E7EF));
  }
}

class _SocialButtonsRow extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  const _SocialButtonsRow({
    required this.isLoading,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialCircleButton(
          onTap: isLoading ? null : onGoogleTap,
          child: Image.asset(
            AppAssets.googleLogo,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
        const SizedBox(width: 18),
        _SocialCircleButton(
          onTap: isLoading ? null : onAppleTap,
          child: const Icon(
            Icons.apple_rounded,
            size: 27,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _SocialCircleButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.white.withValues(alpha: 0.88),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 54,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E7EF), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textDark.withValues(alpha: 0.055),
                    blurRadius: 16,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupFooter extends StatelessWidget {
  final VoidCallback onSignupTap;

  const _SignupFooter({required this.onSignupTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Don’t have an account? ',
            style: TextStyle(
              fontSize: 14.2,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark.withValues(alpha: 0.88),
            ),
          ),
          GestureDetector(
            onTap: onSignupTap,
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 14.2,
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryViolet,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumLoginBackground extends StatelessWidget {
  const _PremiumLoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(color: Color(0xFFFFF7EC)),
          ),
        ),
        Positioned(
          top: -130,
          right: -90,
          child: _BackgroundGlow(
            size: 280,
            color: Colors.white.withValues(alpha: 0.92),
          ),
        ),
        Positioned(
          top: 145,
          left: -120,
          child: _BackgroundGlow(
            size: 250,
            color: AppTheme.primaryViolet.withValues(alpha: 0.09),
          ),
        ),
        Positioned(
          right: -100,
          bottom: 120,
          child: _BackgroundGlow(
            size: 250,
            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
          ),
        ),
        Positioned(
          left: -110,
          bottom: -130,
          child: _BackgroundGlow(
            size: 330,
            color: const Color(0xFFD9B7E5).withValues(alpha: 0.18),
          ),
        ),
        Positioned.fill(child: CustomPaint(painter: _LoginBackgroundPainter())),
      ],
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _BackgroundGlow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.18), Colors.transparent],
        ),
      ),
    );
  }
}

class _LoginBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppTheme.primaryViolet.withValues(alpha: 0.046)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.38)
      ..strokeWidth = 1.15
      ..style = PaintingStyle.stroke;

    for (double x = 18; x < size.width; x += 58) {
      for (double y = 32; y < size.height; y += 58) {
        canvas.drawCircle(Offset(x, y), 1.6, dotPaint);
      }
    }

    final topPath = Path()
      ..moveTo(-25, size.height * 0.18)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.12,
        size.width * 0.60,
        size.height * 0.18,
      )
      ..quadraticBezierTo(
        size.width * 0.90,
        size.height * 0.23,
        size.width + 35,
        size.height * 0.16,
      );

    canvas.drawPath(topPath, linePaint);

    final bottomPath = Path()
      ..moveTo(-30, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.32,
        size.height * 0.70,
        size.width * 0.72,
        size.height * 0.78,
      )
      ..quadraticBezierTo(
        size.width * 0.94,
        size.height * 0.82,
        size.width + 40,
        size.height * 0.74,
      );

    canvas.drawPath(bottomPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
