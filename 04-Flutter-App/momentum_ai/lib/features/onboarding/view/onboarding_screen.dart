import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momentum_ai/features/onboarding/view/model/onboarding_page_model.dart';
import 'package:momentum_ai/features/onboarding/view/view_model/onboarding_view_model.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _floatingController;

  @override
  void initState() {
    super.initState();

    _setupSystemBars();

    _pageController = PageController();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
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
    _pageController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    final state = ref.read(onboardingViewModelProvider);

    if (state.isLastPage) {
      context.go(AppRoutes.login);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  void _goToPreviousPage() {
    final state = ref.read(onboardingViewModelProvider);

    if (state.isFirstPage) {
      return;
    }

    _pageController.previousPage(
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  void _skipOnboarding() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);

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
            const _OnboardingBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 22),
                child: Column(
                  children: [
                    _TopBar(
                      currentPage: state.currentPage,
                      totalPages: state.pages.length,
                      onSkipTap: _skipOnboarding,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: state.pages.length,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          ref
                              .read(onboardingViewModelProvider.notifier)
                              .updatePage(index);
                        },
                        itemBuilder: (context, index) {
                          final page = state.pages[index];

                          return _OnboardingPage(
                            page: page,
                            floatingController: _floatingController,
                          );
                        },
                      ),
                    ),
                    _BottomNavigation(
                      currentPage: state.currentPage,
                      totalPages: state.pages.length,
                      isFirstPage: state.isFirstPage,
                      isLastPage: state.isLastPage,
                      onBackTap: _goToPreviousPage,
                      onNextTap: _goToNextPage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkipTap;

  const _TopBar({
    required this.currentPage,
    required this.totalPages,
    required this.onSkipTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _MiniProgressDots(currentPage: currentPage, totalPages: totalPages),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSkipTap,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B7280),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: const Size(44, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'skip',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.1,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageModel page;
  final AnimationController floatingController;

  const _OnboardingPage({required this.page, required this.floatingController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatingController,
      builder: (context, child) {
        final floatValue = math.sin(floatingController.value * math.pi);
        final verticalOffset = floatValue * -10;

        return Column(
          children: [
            const Spacer(flex: 1),
            Transform.translate(
              offset: Offset(0, verticalOffset),
              child: _IllustrationStage(image: page.image),
            ),
            const SizedBox(height: 34),
            _PremiumTextBlock(title: page.title, description: page.description),
            const Spacer(flex: 2),
          ],
        );
      },
    );
  }
}

class _IllustrationStage extends StatelessWidget {
  final String image;

  const _IllustrationStage({required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 26,
            child: Container(
              width: 238,
              height: 238,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.72),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA25DCB).withValues(alpha: 0.10),
                    blurRadius: 42,
                    spreadRadius: 10,
                    offset: const Offset(0, 18),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.95),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: const Offset(-8, -10),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 14,
            right: 42,
            child: _SoftBubble(
              size: 36,
              color: AppTheme.primaryViolet.withValues(alpha: 0.11),
            ),
          ),
          Positioned(
            left: 38,
            bottom: 34,
            child: _SoftBubble(
              size: 28,
              color: AppTheme.primaryBlue.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            right: 62,
            bottom: 20,
            child: _SoftBubble(
              size: 18,
              color: AppTheme.primaryCyan.withValues(alpha: 0.18),
            ),
          ),
          Image.asset(image, height: 230, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class _PremiumTextBlock extends StatelessWidget {
  final String title;
  final String description;

  const _PremiumTextBlock({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.sora(
            fontSize: 24,
            height: 1.14,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: const Color(0xFF171923),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 14.5,
              height: 1.55,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
              color: const Color(0xFF7C8491),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isFirstPage;
  final bool isLastPage;
  final VoidCallback onBackTap;
  final VoidCallback onNextTap;

  const _BottomNavigation({
    required this.currentPage,
    required this.totalPages,
    required this.isFirstPage,
    required this.isLastPage,
    required this.onBackTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 260),
              opacity: isFirstPage ? 0.45 : 1,
              child: TextButton(
                onPressed: isFirstPage ? null : onBackTap,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6B7280),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(52, 44),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'back',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.1,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ),
          _LargePageIndicator(currentPage: currentPage, totalPages: totalPages),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: isLastPage
                  ? _GetStartedButton(
                      key: const ValueKey('get-started-button'),
                      onTap: onNextTap,
                    )
                  : _ArrowButton(
                      key: const ValueKey('arrow-button'),
                      onTap: onNextTap,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ArrowButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _NeumorphicTapShell(
      width: 84,
      height: 58,
      borderRadius: 32,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFA45AB5).withValues(alpha: 0.18),
              ),
            ),
          ),
          Positioned(
            right: 14,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFA45AB5).withValues(alpha: 0.28),
              ),
            ),
          ),
          Positioned(
            right: 28,
            child: Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFB766C4), Color(0xFF8F47A8)],
                ),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GetStartedButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _NeumorphicTapShell(
      width: 150,
      height: 58,
      borderRadius: 32,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB766C4), Color(0xFF8F47A8)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C54AE).withValues(alpha: 0.30),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Text(
          'Get started',
          style: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _NeumorphicTapShell extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback onTap;
  final Widget child;

  const _NeumorphicTapShell({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C54AE).withValues(alpha: 0.22),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.85),
                blurRadius: 18,
                offset: const Offset(-8, -8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _MiniProgressDots extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _MiniProgressDots({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: isActive ? 7 : 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF72747A) : const Color(0xFFB9BBC2),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}

class _LargePageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _LargePageIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: isActive ? 24 : 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 3.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFFB766C4), Color(0xFF8F47A8)],
                  )
                : null,
            color: isActive ? null : const Color(0xFFD7B7DB),
          ),
        );
      }),
    );
  }
}

class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground();

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
            color: const Color(0xFFB766C4).withValues(alpha: 0.08),
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

class _SoftBubble extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftBubble({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
      ..color = const Color(0xFFB766C4).withValues(alpha: 0.055)
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
