// lib/features/habits/model/habit_model.dart
import 'package:flutter/material.dart';

class HabitModel {
  final String id;
  final String title;
  final IconData icon;
  final Color iconBgColor;
  final String tag; // e.g., 'Health', 'Learning', 'Wellness'
  final int currentCount;
  final int targetCount;
  final int streak;
  final bool isCompletedToday;

  HabitModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.iconBgColor,
    required this.tag,
    required this.currentCount,
    required this.targetCount,
    required this.streak,
    this.isCompletedToday = false,
  });

  double get progress => targetCount > 0 ? currentCount / targetCount : 0.0;

  HabitModel copyWith({bool? isCompletedToday}) {
    return HabitModel(
      id: id,
      title: title,
      icon: icon,
      iconBgColor: iconBgColor,
      tag: tag,
      currentCount: currentCount,
      targetCount: targetCount,
      streak: streak,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
    );
  }
}
