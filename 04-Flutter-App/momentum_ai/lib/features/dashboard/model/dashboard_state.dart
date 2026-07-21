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

  DashboardState({
    required this.userName,
    required this.notificationCount,
    required this.dailyFocusScore,
    required this.weeklyFocusIncrease,
    required this.tasksCompleted,
    required this.totalTasks,
    required this.focusHours,
    required this.streak,
    required this.xp,
    this.meetings = const [],
    this.priorities = const [],
  });
}

class MeetingModel {
  final String title;
  final String time;
  final int peopleCount;

  MeetingModel({
    required this.title,
    required this.time,
    required this.peopleCount,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      title: json['title'],
      time: json['time'],
      peopleCount: json['peopleCount'],
    );
  }
}

class TaskPriorityModel {
  final String title;
  final String timeEstimate;
  final String type;
  final List<String> tags;

  TaskPriorityModel({
    required this.title,
    required this.timeEstimate,
    required this.type,
    this.tags = const [],
  });

  factory TaskPriorityModel.fromJson(Map<String, dynamic> json) {
    return TaskPriorityModel(
      title: json['title'],
      timeEstimate: json['timeEstimate'],
      type: json['type'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
