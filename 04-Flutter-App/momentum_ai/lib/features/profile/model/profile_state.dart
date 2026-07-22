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
    this.name = 'User',
    this.role = 'Member', // Default 'Member' set kiya
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

  // 🔥 FIX: Role ko Capitalize karne ka function
  static String _formatRole(String role) {
    if (role.isEmpty) return 'Member';
    return role[0].toUpperCase() + role.substring(1);
  }

  factory ProfileState.fromJson(Map<String, dynamic> json) {
    return ProfileState(
      name: json['name'] ?? 'User',
      role: _formatRole(
        json['role'] ?? 'Member',
      ), // 🔥 Ab 'user' -> 'User', 'admin' -> 'Admin' ban jayega
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
