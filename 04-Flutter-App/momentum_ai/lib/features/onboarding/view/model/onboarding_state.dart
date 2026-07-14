import 'package:momentum_ai/core/constants/app_assets.dart';
import 'onboarding_page_model.dart';

class OnboardingState {
  final int currentPage;
  final List<OnboardingPageModel> pages;

  const OnboardingState({
    this.currentPage = 0,
    this.pages = const [
      OnboardingPageModel(
        image: AppAssets.onboarding01,
        title: 'Build Momentum Every Day',
        description:
            'Turn your goals, habits, and plans into focused daily action with a smarter personal growth system.',
      ),
      OnboardingPageModel(
        image: AppAssets.onboarding02,
        title: 'Plan Smarter With AI',
        description:
            'Get clear suggestions, better focus, and helpful guidance that keeps you moving toward your goals.',
      ),
      OnboardingPageModel(
        image: AppAssets.onboarding03,
        title: 'Track Progress Clearly',
        description:
            'Monitor your goals, streaks, habits, and growth with a clean dashboard designed for real progress.',
      ),
    ],
  });

  bool get isFirstPage => currentPage == 0;

  bool get isLastPage => currentPage == pages.length - 1;

  OnboardingState copyWith({
    int? currentPage,
    List<OnboardingPageModel>? pages,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      pages: pages ?? this.pages,
    );
  }
}


