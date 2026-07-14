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
}


