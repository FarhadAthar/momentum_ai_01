import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        systemNavigationBarColor: Color(0xFFFFF7EC),
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
      duration: const Duration(milliseconds: 2400),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.72,
          end: 0.92,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 72,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.92,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 28,
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
      if (!mounted) return;

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
        systemNavigationBarColor: Color(0xFFFFF7EC),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7EC),
        body: Stack(
          children: [
            const _PremiumWarmBackground(),
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
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([introController, pulseController]),
        builder: (context, child) {
          final pulse = pulseController.value;
          final rotate = pulseController.value * math.pi * 2;

          return Opacity(
            opacity: logoOpacity.value,
            child: Transform.scale(
              scale: logoScale.value,
              child: SizedBox(
                width: 292,
                height: 226,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _LogoAuraGlow(pulse: pulse),
                    CustomPaint(
                      size: const Size(250, 210),
                      painter: _LogoOrbitPainter(
                        progress: pulse,
                        rotation: rotate,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Container(
                        width: 155,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withValues(
                                alpha: 0.18,
                              ),
                              blurRadius: 34,
                              spreadRadius: 8,
                            ),
                            BoxShadow(
                              color: AppTheme.primaryViolet.withValues(
                                alpha: 0.16,
                              ),
                              blurRadius: 38,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -4),
                      child: Image.asset(
                        AppAssets.logo,
                        width: 172,
                        height: 172,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoAuraGlow extends StatelessWidget {
  final double pulse;

  const _LogoAuraGlow({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 230 + (pulse * 36),
          height: 230 + (pulse * 36),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.primaryBlue.withValues(alpha: 0.24 + pulse * 0.08),
                AppTheme.primaryViolet.withValues(alpha: 0.16 + pulse * 0.06),
                AppTheme.primaryCyan.withValues(alpha: 0.06),
                Colors.transparent,
              ],
              stops: const [0.0, 0.38, 0.62, 1.0],
            ),
          ),
        ),
        Container(
          width: 174 + (pulse * 24),
          height: 174 + (pulse * 24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.38),
                AppTheme.primaryBlue.withValues(alpha: 0.12),
                Colors.transparent,
              ],
              stops: const [0.0, 0.48, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoOrbitPainter extends CustomPainter {
  final double progress;
  final double rotation;

  const _LogoOrbitPainter({required this.progress, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final firstPaint = Paint()
      ..color = AppTheme.primaryBlue.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.15;

    final secondPaint = Paint()
      ..color = AppTheme.primaryViolet.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.05;

    final dotPaint = Paint()
      ..color = AppTheme.primaryBlue.withValues(alpha: 0.32)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * 0.035);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawOval(
      Rect.fromCenter(center: center, width: 218, height: 126),
      firstPaint,
    );

    canvas.restore();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-rotation * 0.028);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawOval(
      Rect.fromCenter(center: center, width: 190, height: 108),
      secondPaint,
    );

    canvas.restore();

    final angle = (progress * math.pi * 2) - math.pi / 4;
    final dotOffset = Offset(
      center.dx + math.cos(angle) * 108,
      center.dy + math.sin(angle) * 52,
    );

    canvas.drawCircle(dotOffset, 3.2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _LogoOrbitPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.rotation != rotation;
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
                    style: TextStyle(
                      fontSize: 41,
                      height: 1.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2.1,
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
                  style: TextStyle(
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
                style: TextStyle(
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

class _PremiumWarmBackground extends StatelessWidget {
  const _PremiumWarmBackground();

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
          top: -120,
          right: -90,
          child: _BackgroundGlow(
            size: 260,
            color: Colors.white.withValues(alpha: 0.90),
          ),
        ),
        Positioned(
          left: -110,
          bottom: -120,
          child: _BackgroundGlow(
            size: 300,
            color: const Color(0xFFD9B7E5).withValues(alpha: 0.22),
          ),
        ),
        Positioned(
          right: -90,
          bottom: 80,
          child: _BackgroundGlow(
            size: 220,
            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
          ),
        ),
        Positioned(
          top: 120,
          left: -90,
          child: _BackgroundGlow(
            size: 210,
            color: AppTheme.primaryViolet.withValues(alpha: 0.09),
          ),
        ),
        Positioned.fill(child: CustomPaint(painter: _SoftPatternPainter())),
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

class _SoftPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.34)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppTheme.primaryViolet.withValues(alpha: 0.055)
      ..style = PaintingStyle.fill;

    for (double x = 20; x < size.width; x += 58) {
      for (double y = 40; y < size.height; y += 58) {
        canvas.drawCircle(Offset(x, y), 1.8, dotPaint);
      }
    }

    final path = Path()
      ..moveTo(-20, size.height * 0.24)
      ..quadraticBezierTo(
        size.width * 0.32,
        size.height * 0.18,
        size.width * 0.62,
        size.height * 0.25,
      )
      ..quadraticBezierTo(
        size.width * 0.90,
        size.height * 0.31,
        size.width + 20,
        size.height * 0.22,
      );

    canvas.drawPath(path, linePaint);

    final secondPath = Path()
      ..moveTo(-20, size.height * 0.76)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.68,
        size.width * 0.76,
        size.height * 0.76,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.79,
        size.width + 30,
        size.height * 0.72,
      );

    canvas.drawPath(secondPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


