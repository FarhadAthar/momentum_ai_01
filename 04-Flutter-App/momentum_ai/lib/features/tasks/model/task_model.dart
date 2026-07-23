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

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    Color parseColor(dynamic colorData) {
      if (colorData is int) {
        return Color(colorData);
      } else if (colorData is String) {
        final hex = colorData.replaceAll('#', '');
        if (hex.length == 6) {
          return Color(int.parse('0xFF$hex'));
        } else if (hex.length == 8) {
          return Color(int.parse('0x$hex'));
        }
      }
      return const Color(0xFF6366F1);
    }

    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      priority: json['priority'] ?? 'Medium',
      tags: List<String>.from(json['tags'] ?? []),
      time: json['time'] ?? '',
      isAIGenerated: json['isAIGenerated'] ?? false,
      accentColor: parseColor(json['accentColor']),
    );
  }

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
