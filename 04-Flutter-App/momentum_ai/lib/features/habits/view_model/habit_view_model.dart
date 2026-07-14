// lib/features/habits/view_model/habit_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/habit_model.dart';

class HabitState {
  final List<HabitModel> habits;
  final int weeklyScore;
  final int bestStreak;
  final int habitsThisWeek;

  HabitState({
    required this.habits,
    this.weeklyScore = 78,
    this.bestStreak = 22,
    this.habitsThisWeek = 47,
  });
}

final habitViewModelProvider = NotifierProvider<HabitViewModel, HabitState>(() {
  return HabitViewModel();
});

class HabitViewModel extends Notifier<HabitState> {
  @override
  HabitState build() {
    return HabitState(habits: _mockHabits);
  }

  static final List<HabitModel> _mockHabits = [
    HabitModel(
      id: '1',
      title: 'Morning Workout',
      icon: Icons.fitness_center_rounded,
      iconBgColor: const Color(0xFFFFF3E0),
      tag: 'Health',
      currentCount: 14,
      targetCount: 30,
      streak: 14,
      isCompletedToday: true,
    ),
    HabitModel(
      id: '2',
      title: 'Read 20 Pages',
      icon: Icons.menu_book_rounded,
      iconBgColor: const Color(0xFFF3E5F5),
      tag: 'Learning',
      currentCount: 8,
      targetCount: 21,
      streak: 8,
      isCompletedToday: false,
    ),
    HabitModel(
      id: '3',
      title: 'Meditate 10 min',
      icon: Icons.self_improvement_rounded,
      iconBgColor: const Color(0xFFE8F5E9),
      tag: 'Wellness',
      currentCount: 22,
      targetCount: 30,
      streak: 22,
      isCompletedToday: true,
    ),
    HabitModel(
      id: '4',
      title: 'Drink 8 Glasses',
      icon: Icons.water_drop_rounded,
      iconBgColor: const Color(0xFFE3F2FD),
      tag: 'Health',
      currentCount: 5,
      targetCount: 30,
      streak: 5,
      isCompletedToday: false,
    ),
  ];

  void toggleHabit(String id) {
    final updatedList = state.habits.map((habit) {
      if (habit.id == id) {
        // In a real backend, we would also increment currentCount here.
        return habit.copyWith(isCompletedToday: !habit.isCompletedToday);
      }
      return habit;
    }).toList();

    state = HabitState(
      habits: updatedList,
      weeklyScore: state.weeklyScore,
      bestStreak: state.bestStreak,
      habitsThisWeek: state.habitsThisWeek,
    );
  }
}
