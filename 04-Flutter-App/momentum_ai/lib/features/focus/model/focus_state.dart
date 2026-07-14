class FocusState {
  final int currentSession;
  final int totalSessions;
  final String currentTask;
  final List<String> focusQueue;
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final String selectedSound;

  const FocusState({
    this.currentSession = 2,
    this.totalSessions = 4,
    this.currentTask = 'Prepare client proposal',
    this.focusQueue = const [
      'Prepare client proposal',
      'Review Q3 report',
      'Send team update email',
      'Design new mockups',
    ],
    this.remainingSeconds = 983, // 16:23
    this.totalSeconds = 1500, // 25 min
    this.isRunning = false,
    this.selectedSound = 'Rain',
  });

  FocusState copyWith({
    int? currentSession,
    int? totalSessions,
    String? currentTask,
    List<String>? focusQueue,
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    String? selectedSound,
  }) {
    return FocusState(
      currentSession: currentSession ?? this.currentSession,
      totalSessions: totalSessions ?? this.totalSessions,
      currentTask: currentTask ?? this.currentTask,
      focusQueue: focusQueue ?? this.focusQueue,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      selectedSound: selectedSound ?? this.selectedSound,
    );
  }

  double get progress =>
      totalSeconds > 0 ? (totalSeconds - remainingSeconds) / totalSeconds : 0;
  int get completedSessions => currentSession - 1;
}


