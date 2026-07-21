import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final String priority;
  final List<String> tags;
  final String time;
  final bool isAIGenerated;
  final Color accentColor;

  TaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.priority,
    required this.tags,
    required this.time,
    this.isAIGenerated = false,
    required this.accentColor,
  });

  // 👇 Backend JSON se model banane ke liye
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
      priority: json['priority'] ?? 'Medium',
      tags: List<String>.from(json['tags'] ?? []),
      time: json['time'] ?? '',
      isAIGenerated: json['isAIGenerated'] ?? false,
      // Color ko int se parse karna (agar backend se aata hai)
      accentColor: json['accentColor'] != null
          ? Color(json['accentColor'])
          : const Color(0xFF6366F1),
    );
  }

  // 👇 Model ko Backend JSON mein convert karne ke liye
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'priority': priority,
      'tags': tags,
      'time': time,
      'isAIGenerated': isAIGenerated,
    };
  }
}
