import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                style: TextStyle(
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final stageHeight = (constraints.maxHeight * 0.52)
            .clamp(320.0, 370.0)
            .toDouble();

        final imageHeight = (stageHeight * 0.86).clamp(275.0, 320.0).toDouble();

        return AnimatedBuilder(
          animation: floatingController,
          builder: (context, child) {
            final floatValue = math.sin(floatingController.value * math.pi);
            final verticalOffset = floatValue * -10;

            return Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.025),
                Transform.translate(
                  offset: Offset(0, verticalOffset),
                  child: _IllustrationStage(
                    image: page.image,
                    stageHeight: stageHeight,
                    imageHeight: imageHeight,
                  ),
                ),
                const SizedBox(height: 26),
                _PremiumTextBlock(
                  title: page.title,
                  description: page.description,
                ),
                const Spacer(),
              ],
            );
          },
        );
      },
    );
  }
}

class _IllustrationStage extends StatelessWidget {
  final String image;
  final double stageHeight;
  final double imageHeight;

  const _IllustrationStage({
    required this.image,
    required this.stageHeight,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: stageHeight,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 18,
            right: 38,
            child: _SoftBubble(
              size: 38,
              color: AppTheme.primaryViolet.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            left: 34,
            bottom: 54,
            child: _SoftBubble(
              size: 30,
              color: AppTheme.primaryBlue.withValues(alpha: 0.09),
            ),
          ),
          Positioned(
            right: 58,
            bottom: 34,
            child: _SoftBubble(
              size: 19,
              color: AppTheme.primaryCyan.withValues(alpha: 0.16),
            ),
          ),
          Positioned(
            bottom: 28,
            child: Container(
              width: 190,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryViolet.withValues(alpha: 0.10),
                    blurRadius: 34,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Image.asset(image, height: imageHeight, fit: BoxFit.contain),
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
          style: TextStyle(
            fontSize: 25.5,
            height: 1.12,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.9,
            color: const Color(0xFF171923),
          ),
        ),
        const SizedBox(height: 17),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.7,
              height: 1.56,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.12,
              color: const Color(0xFF7C8491),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final bool isFirstPage;
  final bool isLastPage;
  final VoidCallback onBackTap;
  final VoidCallback onNextTap;

  const _BottomNavigation({
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.1,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ),
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
      width: 86,
      height: 52,
      borderRadius: 30,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryViolet.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            right: 11,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryBlue.withValues(alpha: 0.17),
              ),
            ),
          ),
          Positioned(
            right: 22,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryBlue,
                    Color(0xFF6258FF),
                    AppTheme.primaryViolet,
                  ],
                ),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 27,
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
      width: 154,
      height: 60,
      borderRadius: 34,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryBlue,
              Color(0xFF6258FF),
              AppTheme.primaryViolet,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withValues(alpha: 0.24),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: AppTheme.primaryViolet.withValues(alpha: 0.18),
              blurRadius: 32,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Text(
          'Get started',
          style: TextStyle(
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
                color: AppTheme.primaryBlue.withValues(alpha: 0.13),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: AppTheme.primaryViolet.withValues(alpha: 0.11),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.82),
                blurRadius: 16,
                offset: const Offset(-7, -7),
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
          width: isActive ? 16 : 5,
          height: 5,
          margin: const EdgeInsets.symmetric(horizontal: 2.7),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryBlue : const Color(0xFFB9BBC2),
            borderRadius: BorderRadius.circular(100),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
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
