import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model.dart';
import '../../../core/services/api_service.dart';

final tasksViewModelProvider =
    NotifierProvider<TasksViewModel, AsyncValue<List<TaskModel>>>(() {
      return TasksViewModel();
    });

class TasksViewModel extends Notifier<AsyncValue<List<TaskModel>>> {
  @override
  AsyncValue<List<TaskModel>> build() {
    fetchTasks();
    return const AsyncValue.loading();
  }

  // 1. Fetch - Smart Loading
  Future<void> fetchTasks({bool setLoading = true}) async {
    if (setLoading) state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final rawList = await ApiService.getTasks();
      return rawList.map((e) => TaskModel.fromJson(e)).toList();
    });
  }

  // 2. Add Task
  Future<void> addTask(TaskModel task) async {
    try {
      final createdResponse = await ApiService.createTask(task.toJson());
      final newTask = TaskModel.fromJson(createdResponse['task']);
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, newTask]);
    } catch (e) {
      await fetchTasks(setLoading: false);
      rethrow;
    }
  }

  // 3. Toggle (Production Smoothness)
  Future<void> toggleTaskCompletion(String taskId) async {
    // 1. Optimistic Update (User ko instantly response dikhega)
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

    // 2. Background Sync (Silently API ko update karein)
    try {
      await ApiService.toggleTask(taskId);
      // UI ko rokne ke liye `setLoading: false` use kiya
      await fetchTasks(setLoading: false);
    } catch (e) {
      // Error par wapas rollback karne ke liye fetch karein
      await fetchTasks(setLoading: false);
      rethrow;
    }
  }

  // 🆕 4. Delete Task
  Future<void> deleteTask(String taskId) async {
    try {
      // Backend call
      await ApiService.deleteTask(taskId);
      // UI update: list se hata dein
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.where((t) => t.id != taskId).toList(),
      );
    } catch (e) {
      await fetchTasks(setLoading: false);
      rethrow;
    }
  }
}
