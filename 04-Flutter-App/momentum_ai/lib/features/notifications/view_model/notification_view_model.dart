// lib/features/notifications/view_model/notification_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';

class NotificationState {
  final List<NotificationItem> notifications;

  NotificationState({required this.notifications});
}

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(() {
      return NotificationViewModel();
    });

class NotificationViewModel extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    // Mock data exactly like your screenshot
    return NotificationState(notifications: _mockNotifications);
  }

  static final List<NotificationItem> _mockNotifications = [
    NotificationItem(
      id: '1',
      title: 'Good Morning Briefing',
      description:
          'You have 9 tasks today. Peak focus: 9–11 AM. Start with client proposal!',
      time: '8:00 AM',
      icon: Icons.coffee_rounded,
      iconBgColor: const Color(0xFFFFE0B2),
    ),
    NotificationItem(
      id: '2',
      title: 'Focus Time!',
      description:
          'Your scheduled deep work block starts now. Notifications muted for 90 min.',
      time: '8:00 AM',
      icon: Icons.flash_on_rounded,
      iconBgColor: const Color(0xFFE1BEE7),
    ),
    NotificationItem(
      id: '3',
      title: 'Meeting Reminder',
      description: 'Team Standup in 15 minutes · Zoom · 10 people',
      time: '9:45 AM',
      icon: Icons.calendar_today_rounded,
      iconBgColor: const Color(0xFFFFCDD2),
    ),
    NotificationItem(
      id: '4',
      title: 'Goal Milestone!',
      description: "You're 65% toward your SaaS Launch goal. Keep it up!",
      time: 'Yesterday',
      icon: Icons.flag_rounded,
      iconBgColor: const Color(0xFFD1C4E9),
    ),
    NotificationItem(
      id: '5',
      title: 'Streak Alert',
      description: 'Complete your habits today to keep your 12-day streak!',
      time: 'Yesterday',
      icon: Icons.local_fire_department_rounded,
      iconBgColor: const Color(0xFFFFF9C4),
    ),
    NotificationItem(
      id: '6',
      title: 'AI Suggestion',
      description: 'You have 3 overdue tasks. Want me to reschedule them?',
      time: '2 days ago',
      icon: Icons.smart_toy_rounded,
      iconBgColor: const Color(0xFFF3E5F5),
    ),
  ];

  void markAllRead() {
    final updatedList = state.notifications
        .map((item) => item.copyWith(isUnread: false))
        .toList();
    state = NotificationState(notifications: updatedList);
  }
}
