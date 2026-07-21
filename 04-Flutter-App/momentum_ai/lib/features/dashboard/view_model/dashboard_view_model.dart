import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/dashboard_state.dart';
import '../../../core/services/api_service.dart';

final dashboardViewModelProvider =
    NotifierProvider<DashboardViewModel, AsyncValue<DashboardState>>(() {
      return DashboardViewModel();
    });

class DashboardViewModel extends Notifier<AsyncValue<DashboardState>> {
  @override
  AsyncValue<DashboardState> build() {
    fetchDashboard();
    return const AsyncValue.loading();
  }

  Future<void> fetchDashboard() async {
    state = const AsyncValue.loading();
    try {
      final data = await ApiService.getDashboardData();
      final meetings = (data['meetings'] as List)
          .map((e) => MeetingModel.fromJson(e))
          .toList();
      final priorities = (data['priorities'] as List)
          .map((e) => TaskPriorityModel.fromJson(e))
          .toList();
      final dashboardState = DashboardState(
        userName: data['userName'] ?? 'Ahmed',
        notificationCount: data['notificationCount'] ?? 0,
        dailyFocusScore: data['dailyFocusScore'] ?? 0,
        weeklyFocusIncrease: data['weeklyFocusIncrease'] ?? 0,
        tasksCompleted: data['tasksCompleted'] ?? 0,
        totalTasks: data['totalTasks'] ?? 0,
        focusHours: data['focusHours'] ?? '0h',
        streak: data['streak'] ?? 0,
        xp: data['xp'] ?? 0,
        meetings: meetings,
        priorities: priorities,
      );
      state = AsyncValue.data(dashboardState);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
