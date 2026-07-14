import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/splash_state.dart';

final splashViewModelProvider = NotifierProvider<SplashViewModel, SplashState>(
  SplashViewModel.new,
);

class SplashViewModel extends Notifier<SplashState> {
  @override
  SplashState build() {
    return const SplashState();
  }

  Future<void> startSplashFlow() async {
    await Future.delayed(const Duration(milliseconds: 3600));

    state = state.copyWith(isFinished: true);
  }
}


