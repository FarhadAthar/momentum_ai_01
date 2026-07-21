import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model.dart';

final tasksViewModelProvider =
    NotifierProvider<TasksViewModel, AsyncValue<List<TaskModel>>>(() {
      return TasksViewModel();
    });

class TasksViewModel extends Notifier<AsyncValue<List<TaskModel>>> {
  @override
  AsyncValue<List<TaskModel>> build() {
    fetchTasks(); // API call shuru karein
    return const AsyncValue.loading();
  }

  // 1. API se Tasks fetch karna
  Future<void> fetchTasks() async {
    state = const AsyncValue.loading();
    try {
      // TODO: Actual Backend API ka connection
      // final rawList = await ApiService.getTasks();
      // final tasks = rawList.map((e) => TaskModel.fromJson(e)).toList();

      // Mock data for testing (Kyunke backend abhi tasks routes ready nahi)
      await Future.delayed(const Duration(milliseconds: 600));
      final tasks = [
        TaskModel(
          id: '1',
          title: 'Prepare client proposal',
          isCompleted: false,
          priority: 'High',
          tags: ['Work'],
          time: 'Today 5 PM',
          isAIGenerated: true,
          accentColor: const Color(0xFF6366F1),
        ),
        TaskModel(
          id: '2',
          title: 'Review Q3 report',
          isCompleted: true,
          priority: 'Medium',
          tags: ['Finance'],
          time: 'Tomorrow',
          isAIGenerated: false,
          accentColor: const Color(0xFFD97706),
        ),
        TaskModel(
          id: '3',
          title: 'Team standup',
          isCompleted: false,
          priority: 'Low',
          tags: ['Meeting'],
          time: 'Today 10 AM',
          isAIGenerated: false,
          accentColor: const Color(0xFF14B8A6),
        ),
      ];
      state = AsyncValue.data(tasks);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // 2. Naya Task add karna
  Future<void> addTask(TaskModel task) async {
    try {
      // Backend API call
      // final created = await ApiService.createTask(task.toJson());
      // final newTask = TaskModel.fromJson(created);

      // Optimistic Update (Mock)
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, task]);
    } catch (e) {
      // Error par wapas fetch karein
      fetchTasks();
    }
  }

  // 3. Task Complete/Uncomplete karna
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      // Backend API call
      // await ApiService.toggleTask(taskId);

      // Local Optimistic Update (Mock)
      final currentList = state.value ?? [];
      final updatedList = currentList.map((task) {
        if (task.id == taskId) {
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
      state = AsyncValue.data(updatedList);
    } catch (e) {
      fetchTasks(); // Refresh on error
    }
  }
}
