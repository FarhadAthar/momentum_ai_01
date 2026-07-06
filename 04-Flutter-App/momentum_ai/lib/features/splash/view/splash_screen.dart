import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_assets.dart';
import '../view_model/splash_view_model.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _pulseController;
  late final AnimationController _progressController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textSlide;
  late final Animation<double> _textOpacity;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _setupSystemBars();
    _setupAnimations();
    _startAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashViewModelProvider.notifier).startSplashFlow();
    });
  }

  void _setupSystemBars() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
    );
  }

  void _setupAnimations() {
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.68,
          end: 0.92,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.92,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 30,
      ),
    ]).animate(_introController);

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<double>(begin: 24, end: 0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.48, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.48, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  void _startAnimations() {
    _introController.forward();
    _pulseController.repeat(reverse: true);
    _progressController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashViewModelProvider, (previous, next) {
      if (next.isFinished && !_hasNavigated) {
        _hasNavigated = true;
        context.go(AppRoutes.onboarding);
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const _PremiumLightBackground(),
            SafeArea(
              bottom: true,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),
                      _AnimatedLogo(
                        introController: _introController,
                        pulseController: _pulseController,
                        logoScale: _logoScale,
                        logoOpacity: _logoOpacity,
                      ),
                      const SizedBox(height: 34),
                      _AnimatedText(
                        introController: _introController,
                        textOpacity: _textOpacity,
                        textSlide: _textSlide,
                      ),
                      const Spacer(flex: 2),
                      _AnimatedProgressBar(
                        progressController: _progressController,
                        textOpacity: _textOpacity,
                      ),
                      const SizedBox(height: 42),
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

class _AnimatedLogo extends StatelessWidget {
  final AnimationController introController;
  final AnimationController pulseController;
  final Animation<double> logoScale;
  final Animation<double> logoOpacity;

  const _AnimatedLogo({
    required this.introController,
    required this.pulseController,
    required this.logoScale,
    required this.logoOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([introController, pulseController]),
      builder: (context, child) {
        final pulse = pulseController.value;

        return Opacity(
          opacity: logoOpacity.value,
          child: Transform.scale(
            scale: logoScale.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 258 + (pulse * 36),
                  height: 258 + (pulse * 36),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primaryBlue.withValues(
                          alpha: 0.24 + pulse * 0.10,
                        ),
                        AppTheme.primaryViolet.withValues(
                          alpha: 0.16 + pulse * 0.08,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 178,
                  height: 178,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.82),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.18),
                        blurRadius: 42,
                        spreadRadius: 2,
                        offset: const Offset(0, 18),
                      ),
                      BoxShadow(
                        color: AppTheme.primaryViolet.withValues(alpha: 0.14),
                        blurRadius: 38,
                        spreadRadius: 1,
                        offset: const Offset(0, -10),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.95),
                      width: 1.2,
                    ),
                  ),
                  child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedText extends StatelessWidget {
  final AnimationController introController;
  final Animation<double> textOpacity;
  final Animation<double> textSlide;

  const _AnimatedText({
    required this.introController,
    required this.textOpacity,
    required this.textSlide,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: introController,
      builder: (context, child) {
        return Opacity(
          opacity: textOpacity.value,
          child: Transform.translate(
            offset: Offset(0, textSlide.value),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppTheme.primaryBlue,
                        Color(0xFF6258FF),
                        AppTheme.primaryViolet,
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'Momentum AI',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sora(
                      fontSize: 40,
                      height: 1.02,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2.0,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.20),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        Shadow(
                          color: AppTheme.primaryViolet.withValues(alpha: 0.14),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your Personal Productivity Assistant',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 14.8,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05,
                    color: AppTheme.textMuted.withValues(alpha: 0.96),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  final AnimationController progressController;
  final Animation<double> textOpacity;

  const _AnimatedProgressBar({
    required this.progressController,
    required this.textOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressController,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              height: 8,
              width: 220,
              padding: const EdgeInsets.all(1.2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progressController.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryBlue,
                            Color(0xFF6D5CFF),
                            AppTheme.primaryViolet,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            FadeTransition(
              opacity: textOpacity,
              child: Text(
                'Building your daily momentum...',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.1,
                  color: AppTheme.textMuted,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PremiumLightBackground extends StatelessWidget {
  const _PremiumLightBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: Colors.white)),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, AppTheme.background, Color(0xFFF3F6FF)],
              ),
            ),
          ),
        ),
        Positioned(
          top: -95,
          right: -80,
          child: _GlowBlob(
            size: 230,
            color: AppTheme.primaryViolet.withValues(alpha: 0.20),
          ),
        ),
        Positioned(
          top: 170,
          left: -110,
          child: _GlowBlob(
            size: 260,
            color: AppTheme.primaryBlue.withValues(alpha: 0.18),
          ),
        ),
        Positioned(
          bottom: -120,
          right: -100,
          child: _GlowBlob(
            size: 300,
            color: AppTheme.primaryCyan.withValues(alpha: 0.16),
          ),
        ),
        Positioned.fill(child: CustomPaint(painter: _SubtlePatternPainter())),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.08), Colors.transparent],
        ),
      ),
    );
  }
}

class _SubtlePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryBlue.withValues(alpha: 0.030)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 42.0;

    for (double x = -20; x < size.width + 40; x += spacing) {
      for (double y = -20; y < size.height + 40; y += spacing) {
        final rect = Rect.fromCenter(
          center: Offset(x, y),
          width: 16,
          height: 16,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(5)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
