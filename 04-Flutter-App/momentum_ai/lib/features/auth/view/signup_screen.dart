import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../view_model/auth_view_model.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final FocusNode _fullNameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    _setupSystemBars();

    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _fullNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  Future<void> _handleSignup() async {
    FocusScope.of(context).unfocus();

    final authState = ref.read(authViewModelProvider);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!authState.acceptTerms) {
      _showSnackBar('Please accept terms and privacy policy');
      return;
    }

    try {
      // ViewModel se signUp call karein
      await ref
          .read(authViewModelProvider.notifier)
          .signUp(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;

      // Success Message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully! Please Login.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.textDark,
        ),
      );

      // 🔥 IMPORTANT FIX: Dashboard ki jagah Login page par redirect!
      _goToLogin();
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontWeight: FontWeight.w700)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.textDark,
      ),
    );
  }

  void _goToLogin() {
    context.go(AppRoutes.login);
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
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFFFF7EC),
        body: Stack(
          children: [
            const _PremiumSignupBackground(), // 🟢 Ab ye class file mein maujood hai!
            SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: FocusScope.of(context).unfocus,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 40,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const _SignupHeader(),
                              const SizedBox(height: 18),
                              _SignupGlassCard(
                                formKey: _formKey,
                                fullNameController: _fullNameController,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                confirmPasswordController:
                                    _confirmPasswordController,
                                fullNameFocusNode: _fullNameFocusNode,
                                emailFocusNode: _emailFocusNode,
                                passwordFocusNode: _passwordFocusNode,
                                confirmPasswordFocusNode:
                                    _confirmPasswordFocusNode,
                                isSignupPasswordVisible:
                                    authState.isSignupPasswordVisible,
                                isConfirmPasswordVisible:
                                    authState.isConfirmPasswordVisible,
                                acceptTerms: authState.acceptTerms,
                                isLoading: authState.isLoading,
                                onToggleSignupPassword: ref
                                    .read(authViewModelProvider.notifier)
                                    .toggleSignupPasswordVisibility,
                                onToggleConfirmPassword: ref
                                    .read(authViewModelProvider.notifier)
                                    .toggleConfirmPasswordVisibility,
                                onToggleTerms: ref
                                    .read(authViewModelProvider.notifier)
                                    .toggleAcceptTerms,
                                onSignupTap: _handleSignup,
                              ),
                              const Spacer(),
                              _LoginFooter(onLoginTap: _goToLogin),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignupHeader extends StatelessWidget {
  const _SignupHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            height: 1.0,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.6,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Start building smarter daily momentum.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.8,
            height: 1.4,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.12,
            color: AppTheme.textMuted.withValues(alpha: 0.92),
          ),
        ),
      ],
    );
  }
}

class _SignupGlassCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode fullNameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool isSignupPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool acceptTerms;
  final bool isLoading;
  final VoidCallback onToggleSignupPassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onToggleTerms;
  final VoidCallback onSignupTap;

  const _SignupGlassCard({
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.fullNameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.isSignupPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.acceptTerms,
    required this.isLoading,
    required this.onToggleSignupPassword,
    required this.onToggleConfirmPassword,
    required this.onToggleTerms,
    required this.onSignupTap,
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
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
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
              children: [
                _FieldLabel(text: 'Full Name'),
                const SizedBox(height: 8),
                _PremiumTextField(
                  controller: fullNameController,
                  focusNode: fullNameFocusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  hintText: 'Hamza Ahmad',
                  prefixIcon: Icons.person_outline_rounded,
                  onSubmitted: (_) => emailFocusNode.requestFocus(),
                  validator: _validateName,
                ),
                const SizedBox(height: 14),
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
                const SizedBox(height: 14),
                _FieldLabel(text: 'Password'),
                const SizedBox(height: 8),
                _PremiumTextField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  textInputAction: TextInputAction.next,
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !isSignupPasswordVisible,
                  suffixIcon: isSignupPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: onToggleSignupPassword,
                  onSubmitted: (_) => confirmPasswordFocusNode.requestFocus(),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 14),
                _FieldLabel(text: 'Confirm Password'),
                const SizedBox(height: 8),
                _PremiumTextField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                  textInputAction: TextInputAction.done,
                  hintText: '••••••••',
                  prefixIcon: Icons.verified_user_outlined,
                  obscureText: !isConfirmPasswordVisible,
                  suffixIcon: isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: onToggleConfirmPassword,
                  onSubmitted: (_) => onSignupTap(),
                  validator: (value) {
                    return _validateConfirmPassword(
                      value,
                      passwordController.text,
                    );
                  },
                ),
                const SizedBox(height: 18),
                _TermsRow(acceptTerms: acceptTerms, onTap: onToggleTerms),
                const SizedBox(height: 26),
                _PrimarySignupButton(isLoading: isLoading, onTap: onSignupTap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Full name is required';
    if (name.length < 3) return 'Enter your full name';
    return null;
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

  static String? _validateConfirmPassword(String? value, String password) {
    final confirmPassword = value ?? '';
    if (confirmPassword.isEmpty) return 'Confirm password is required';
    if (confirmPassword != password) return 'Passwords do not match';
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
        fontSize: 13.8,
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
        fontSize: 15.4,
        fontWeight: FontWeight.w700,
        color: AppTheme.textDark,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.8,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF858B98),
        ),
        prefixIcon: Icon(prefixIcon, size: 22, color: const Color(0xFF747B8C)),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 46,
          minHeight: 48,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                onPressed: onSuffixTap,
                splashRadius: 19,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 46, minHeight: 48),
                icon: Icon(
                  suffixIcon,
                  size: 22,
                  color: const Color(0xFF747B8C),
                ),
              ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.78),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide(
            color: const Color(0xFF253047).withValues(alpha: 0.42),
            width: 1.18,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.18),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.5),
        ),
        errorStyle: TextStyle(
          fontSize: 11.3,
          height: 1.12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE5484D),
        ),
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  final bool acceptTerms;
  final VoidCallback onTap;

  const _TermsRow({required this.acceptTerms, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: acceptTerms
                  ? AppTheme.primaryBlue
                  : const Color(0xFFF2F4FA),
              border: Border.all(
                color: acceptTerms
                    ? AppTheme.primaryBlue
                    : const Color(0xFFC8CEDA),
                width: 1.15,
              ),
              boxShadow: acceptTerms
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: acceptTerms
                ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12.7,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF253047),
              ),
              children: const [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms',
                  style: TextStyle(
                    color: AppTheme.primaryViolet,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: AppTheme.primaryViolet,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimarySignupButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _PrimarySignupButton({required this.isLoading, required this.onTap});

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
                        key: ValueKey('signup-loading'),
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Create Account',
                        key: const ValueKey('signup-text'),
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

class _LoginFooter extends StatelessWidget {
  final VoidCallback onLoginTap;

  const _LoginFooter({required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: TextStyle(
              fontSize: 14.2,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark.withValues(alpha: 0.88),
            ),
          ),
          GestureDetector(
            onTap: onLoginTap,
            child: Text(
              'Sign In',
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

// 🟢 Yahan se yeh classes phir se aa gayi hain (Error isliye aa raha tha kyunke yeh delete ho gayi thin)
class _PremiumSignupBackground extends StatelessWidget {
  const _PremiumSignupBackground();

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
          top: 130,
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
        Positioned.fill(
          child: CustomPaint(painter: _SignupBackgroundPainter()),
        ),
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

class _SignupBackgroundPainter extends CustomPainter {
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
      ..moveTo(-25, size.height * 0.16)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.10,
        size.width * 0.60,
        size.height * 0.16,
      )
      ..quadraticBezierTo(
        size.width * 0.90,
        size.height * 0.21,
        size.width + 35,
        size.height * 0.14,
      );

    canvas.drawPath(topPath, linePaint);

    final bottomPath = Path()
      ..moveTo(-30, size.height * 0.80)
      ..quadraticBezierTo(
        size.width * 0.32,
        size.height * 0.72,
        size.width * 0.72,
        size.height * 0.80,
      )
      ..quadraticBezierTo(
        size.width * 0.94,
        size.height * 0.84,
        size.width + 40,
        size.height * 0.76,
      );

    canvas.drawPath(bottomPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
