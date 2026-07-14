// lib/features/tasks/model/task_model.dart
import 'dart:ui';

class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final String priority; // 'High', 'Medium', 'Low'
  final List<String> tags; // 'Work', 'Finance', 'Meeting'
  final String time; // 'Today 5 PM', 'Tomorrow', '2h'
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
}


