import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/onboarding_state.dart';

final onboardingViewModelProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(
      OnboardingViewModel.new,
    );

class OnboardingViewModel extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void updatePage(int pageIndex) {
    state = state.copyWith(currentPage: pageIndex);
  }
}


