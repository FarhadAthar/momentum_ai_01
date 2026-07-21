import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/habit_model.dart';
import '../../../core/services/api_service.dart';

class HabitsState {
  final List<HabitModel> habits;
  final int weeklyScore;
  final int bestStreak;
  final int habitsThisWeek;

  HabitsState({
    required this.habits,
    this.weeklyScore = 78,
    this.bestStreak = 22,
    this.habitsThisWeek = 47,
  });

  factory HabitsState.fromJson(Map<String, dynamic> json) {
    final habitsList = (json['habits'] as List)
        .map((e) => HabitModel.fromJson(e))
        .toList();
    return HabitsState(
      habits: habitsList,
      weeklyScore: json['weeklyScore'] ?? 78,
      bestStreak: json['bestStreak'] ?? 22,
      habitsThisWeek: json['habitsThisWeek'] ?? 47,
    );
  }
}

final habitViewModelProvider =
    NotifierProvider<HabitViewModel, AsyncValue<HabitsState>>(() {
      return HabitViewModel();
    });

class HabitViewModel extends Notifier<AsyncValue<HabitsState>> {
  @override
  AsyncValue<HabitsState> build() {
    fetchHabits();
    return const AsyncValue.loading();
  }

  Future<void> fetchHabits() async {
    state = const AsyncValue.loading();
    try {
      final data =
          await ApiService.getHabits(); // Ab ye Map<String, dynamic> return karega
      final habitsState = HabitsState.fromJson(data);
      state = AsyncValue.data(habitsState);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> toggleHabit(String habitId) async {
    try {
      await ApiService.toggleHabit(habitId);
      fetchHabits();
    } catch (e) {
      // Handle error optionally
    }
  }
}
