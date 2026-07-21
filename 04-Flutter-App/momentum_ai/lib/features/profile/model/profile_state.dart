// lib/features/profile/model/profile_state.dart
class ProfileState {
  final String name;
  final String role;
  final int level;
  final int currentXp;
  final int maxXp;
  final int tasksDone;
  final String focusHours;
  final String habits;
  final int streak;
  final int goals;
  final int notes;

  const ProfileState({
    this.name = 'Ahmed Khan',
    this.role = 'Entrepreneur · Pro Member',
    this.level = 14,
    this.currentXp = 3240,
    this.maxXp = 4000,
    this.tasksDone = 847,
    this.focusHours = '312h',
    this.habits = '94%',
    this.streak = 12,
    this.goals = 8,
    this.notes = 124,
  });

  // 👇 BACKEND API SE DATA AANE PAR MAP KARNE KE LIYE
  factory ProfileState.fromJson(Map<String, dynamic> json) {
    return ProfileState(
      name: json['name'] ?? 'Ahmed Khan',
      role: json['role'] ?? 'Entrepreneur · Pro Member',
      level: json['level'] ?? 14,
      currentXp: json['currentXp'] ?? 3240,
      maxXp: json['maxXp'] ?? 4000,
      tasksDone: json['tasksDone'] ?? 847,
      focusHours: json['focusHours'] ?? '312h',
      habits: json['habits'] ?? '94%',
      streak: json['streak'] ?? 12,
      goals: json['goals'] ?? 8,
      notes: json['notes'] ?? 124,
    );
  }
}
