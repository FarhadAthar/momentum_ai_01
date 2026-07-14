// Dashboard ka State Model
class DashboardState {
  final String userName;
  final int notificationCount;
  final int dailyFocusScore;
  final int weeklyFocusIncrease;
  final int tasksCompleted;
  final int totalTasks;
  final String focusHours;
  final int streak;
  final int xp;
  final List<MeetingModel> meetings;
  final List<TaskPriorityModel> priorities;

  const DashboardState({
    this.userName = 'Ahmed',
    this.notificationCount = 6,
    this.dailyFocusScore = 87,
    this.weeklyFocusIncrease = 12,
    this.tasksCompleted = 14,
    this.totalTasks = 18,
    this.focusHours = '5.2h',
    this.streak = 12,
    this.xp = 340,
    this.meetings = const [],
    this.priorities = const [],
  });

  DashboardState copyWith({
    String? userName,
    int? notificationCount,
    int? dailyFocusScore,
    int? weeklyFocusIncrease,
    int? tasksCompleted,
    int? totalTasks,
    String? focusHours,
    int? streak,
    int? xp,
    List<MeetingModel>? meetings,
    List<TaskPriorityModel>? priorities,
  }) {
    return DashboardState(
      userName: userName ?? this.userName,
      notificationCount: notificationCount ?? this.notificationCount,
      dailyFocusScore: dailyFocusScore ?? this.dailyFocusScore,
      weeklyFocusIncrease: weeklyFocusIncrease ?? this.weeklyFocusIncrease,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      totalTasks: totalTasks ?? this.totalTasks,
      focusHours: focusHours ?? this.focusHours,
      streak: streak ?? this.streak,
      xp: xp ?? this.xp,
      meetings: meetings ?? this.meetings,
      priorities: priorities ?? this.priorities,
    );
  }
}

class MeetingModel {
  final String title;
  final String time;
  final int peopleCount;
  final String? subtitle;

  const MeetingModel({
    required this.title,
    required this.time,
    required this.peopleCount,
    this.subtitle,
  });
}

class TaskPriorityModel {
  final String title;
  final String timeEstimate;
  final String type; // 'urgent', 'work', 'finance', 'meeting'
  final List<String> tags;

  const TaskPriorityModel({
    required this.title,
    required this.timeEstimate,
    required this.type,
    this.tags = const [],
  });
}


