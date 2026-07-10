import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/focus_state.dart';

final focusViewModelProvider = NotifierProvider<FocusViewModel, FocusState>(() {
  return FocusViewModel();
});

class FocusViewModel extends Notifier<FocusState> {
  Timer? _timer;

  @override
  FocusState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const FocusState();
  }

  void toggleTimer() {
    if (state.isRunning) {
      _timer?.cancel();
      state = state.copyWith(isRunning: false);
    } else {
      state = state.copyWith(isRunning: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.remainingSeconds > 0) {
          state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
        } else {
          timer.cancel();
          state = state.copyWith(isRunning: false);
        }
      });
    }
  }

  void skipToNext() {
    _timer?.cancel();
    final queue = state.focusQueue;
    final nextIndex = queue.indexOf(state.currentTask) + 1;
    if (nextIndex < queue.length) {
      state = state.copyWith(
        currentTask: queue[nextIndex],
        remainingSeconds: state.totalSeconds,
        isRunning: false,
      );
    }
  }

  void skipToPrevious() {
    _timer?.cancel();
    final queue = state.focusQueue;
    final prevIndex = queue.indexOf(state.currentTask) - 1;
    if (prevIndex >= 0) {
      state = state.copyWith(
        currentTask: queue[prevIndex],
        remainingSeconds: state.totalSeconds,
        isRunning: false,
      );
    }
  }

  void selectSound(String sound) {
    state = state.copyWith(selectedSound: sound);
  }
}
