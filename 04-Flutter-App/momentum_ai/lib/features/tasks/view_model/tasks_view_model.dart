import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../model/task_model.dart';

final tasksViewModelProvider =
    NotifierProvider<TasksViewModel, List<TaskModel>>(() {
      return TasksViewModel();
    });

class TasksViewModel extends Notifier<List<TaskModel>> {
  @override
  List<TaskModel> build() {
    return _mockTasks;
  }

  static final List<TaskModel> _mockTasks = [
    TaskModel(
      id: '1',
      title: 'Prepare client proposal for Acme Corp',
      isCompleted: false,
      priority: 'High',
      tags: ['Work'],
      time: 'Today 5 PM',
      isAIGenerated: true,
      accentColor: const Color(0xFF4F46E5),
    ),
    TaskModel(
      id: '2',
      title: 'Review Q3 financial report',
      isCompleted: false,
      priority: 'Medium',
      tags: ['Finance'],
      time: 'Tomorrow',
      isAIGenerated: false,
      accentColor: const Color(0xFFD97706),
    ),
    TaskModel(
      id: '3',
      title: 'Team standup call',
      isCompleted: true,
      priority: 'High',
      tags: ['Meeting'],
      time: 'Today 10 AM',
      isAIGenerated: false,
      accentColor: const Color(0xFF059669),
    ),
    TaskModel(
      id: '4',
      title: 'Update project documentation',
      isCompleted: false,
      priority: 'Low',
      tags: ['Work'],
      time: 'Friday',
      isAIGenerated: true,
      accentColor: const Color(0xFF2563EB),
    ),
    TaskModel(
      id: '5',
      title: 'Reply to client emails',
      isCompleted: true,
      priority: 'Medium',
      tags: ['Email'],
      time: 'Today 12 PM',
      isAIGenerated: false,
      accentColor: const Color(0xFF9333EA),
    ),
  ];

  void toggleTaskCompletion(String id) {
    state = state.map((task) {
      if (task.id == id) {
        return TaskModel(
          id: task.id,
          title: task.title,
          isCompleted: !task.isCompleted,
          priority: task.priority,
          tags: task.tags,
          time: task.time,
          isAIGenerated: task.isAIGenerated,
          accentColor: task.accentColor,
        );
      }
      return task;
    }).toList();
  }
}
