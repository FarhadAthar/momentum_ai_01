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

  // 🔥 1. Real Backend se Tasks fetch karna
  Future<void> fetchTasks() async {
    state = const AsyncValue.loading();
    try {
      final rawList = await ApiService.getTasks(); // Real API call
      final tasks = rawList.map((e) => TaskModel.fromJson(e)).toList();
      state = AsyncValue.data(tasks);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // 🔥 2. Real Backend par Naya Task add karna
  Future<void> addTask(TaskModel task) async {
    try {
      // Backend API call
      final createdResponse = await ApiService.createTask(task.toJson());

      // Backend se naya task (with real ID) parse karein
      final newTask = TaskModel.fromJson(createdResponse['task']);

      // Optimistic Update UI mein daal dein
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, newTask]);
    } catch (e) {
      // Error par wapas server se fetch karein (sync rakhne ke liye)
      fetchTasks();
      rethrow; // Bottom sheet ko error dikhane ke liye
    }
  }

  // 🔥 3. Real Backend par Task Complete/Uncomplete karna
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      // Real Backend API call
      await ApiService.toggleTask(taskId);

      // Backend se confirm karne ke baad hi UI update karein (Isse data corrupt nahi hoga)
      fetchTasks();
    } catch (e) {
      // Error par wapas fetch karein
      fetchTasks();
    }
  }
}
