import 'package:flutter/material.dart';

class HabitModel {
  final String id;
  final String title;
  final IconData icon;
  final Color iconBgColor;
  final String tag;
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

  // 👇 BACKEND API SE DATA AANE PAR MAP KARNE KE LIYE
  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'],
      title: json['title'],
      icon: _getIconData(json['icon']),
      iconBgColor: Color(json['iconBgColor'] ?? 0xFFFFF3E0),
      tag: json['tag'],
      currentCount: json['currentCount'] ?? 0,
      targetCount: json['targetCount'] ?? 30,
      streak: json['streak'] ?? 0,
      isCompletedToday: json['isCompletedToday'] ?? false,
    );
  }

  static IconData _getIconData(String? iconName) {
    // Icon mapping logic can be added here. For now, use a default.
    return Icons.fitness_center_rounded;
  }
}
