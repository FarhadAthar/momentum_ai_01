import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/stats_state.dart';

final statsViewModelProvider =
    NotifierProvider<StatsViewModel, AsyncValue<StatsState>>(() {
      return StatsViewModel();
    });

class StatsViewModel extends Notifier<AsyncValue<StatsState>> {
  @override
  AsyncValue<StatsState> build() {
    fetchStats(); // Start fetching data
    return const AsyncValue.loading();
  }

  // 👇 Backend API se data fetch karne ka function
  Future<void> fetchStats() async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Mock delay
      state = AsyncValue.data(const StatsState());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Timeframe change karne ka logic
  void setTimeframe(String timeframe) {
    final current = state.value;
    if (current != null) {
      // Update state with new timeframe
      state = AsyncValue.data(current.copyWith(selectedTimeframe: timeframe));
      // Future: Call fetchStats with new timeframe logic here
      // fetchStats(timeframe);
    }
  }
}
