// lib/features/calendar/view_model/calendar_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../model/calendar_state.dart';

final calendarViewModelProvider =
    NotifierProvider<CalendarViewModel, CalendarState>(() {
      return CalendarViewModel();
    });

class CalendarViewModel extends Notifier<CalendarState> {
  @override
  CalendarState build() {
    // Mock events for Wednesday, July 7, 2025
    final mockEvents = [
      EventModel(
        id: '1',
        title: 'Team Standup',
        time: '10:00 AM',
        duration: '30m',
        attendees: 10,
        stripeColor: const Color(0xFF6366F1),
      ),
      EventModel(
        id: '2',
        title: 'Client Call – Acme Corp',
        time: '2:00 PM',
        duration: '1h',
        attendees: 2,
        stripeColor: const Color(0xFF8B5CF6),
      ),
      EventModel(
        id: '3',
        title: 'Design Review',
        time: '4:00 PM',
        duration: '45m',
        attendees: 4,
        stripeColor: const Color(0xFF14B8A6),
      ),
    ];
    // Default selected date
    final now = DateTime.now();
    // Set to specific date July 7, 2025 to match screenshot
    final defaultDate = DateTime(2025, 7, 7);
    return CalendarState(selectedDate: defaultDate, events: mockEvents);
  }

  void selectDate(DateTime date) {
    // Reset events if needed, or keep mock events for demo
    state = state.copyWith(selectedDate: date);
  }
}
