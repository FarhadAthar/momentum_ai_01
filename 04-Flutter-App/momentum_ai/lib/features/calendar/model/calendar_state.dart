// lib/features/calendar/model/calendar_state.dart
import 'dart:ui';

class EventModel {
  final String id;
  final String title;
  final String time;
  final String duration;
  final int attendees;
  final Color stripeColor;

  const EventModel({
    required this.id,
    required this.title,
    required this.time,
    required this.duration,
    required this.attendees,
    required this.stripeColor,
  });
}

class CalendarState {
  final DateTime selectedDate;
  final List<EventModel> events;

  CalendarState({required this.selectedDate, this.events = const []});

  CalendarState copyWith({DateTime? selectedDate, List<EventModel>? events}) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      events: events ?? this.events,
    );
  }
}
