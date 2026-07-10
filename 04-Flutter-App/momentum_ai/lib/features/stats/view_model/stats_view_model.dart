import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/stats_state.dart';

final statsViewModelProvider = NotifierProvider<StatsViewModel, StatsState>(() {
  return StatsViewModel();
});

class StatsViewModel extends Notifier<StatsState> {
  @override
  StatsState build() {
    return const StatsState();
  }
}
