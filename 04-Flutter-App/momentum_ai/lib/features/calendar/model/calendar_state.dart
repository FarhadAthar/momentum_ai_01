// lib/features/calendar/model/calendar_state.dart
import 'dart:ui';

class EventModel {
  static const Color defaultStripeColor = Color(0xFF6366F1);

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

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: _parseString(json['id'], fallback: ''),
      title: _parseString(
        json['title'] ?? json['name'],
        fallback: 'Untitled event',
      ),
      time: _parseString(
        json['time'] ?? json['startTime'] ?? json['start_time'],
        fallback: '',
      ),
      duration: _parseString(json['duration'], fallback: ''),
      attendees: _parseInt(
        json['attendees'] ?? json['attendeeCount'] ?? json['attendee_count'],
      ),
      stripeColor: _parseColor(
        json['stripeColor'] ?? json['stripe_color'] ?? json['color'],
        fallback: defaultStripeColor,
      ),
    );
  }

  static String _parseString(dynamic value, {required String fallback}) {
    if (value == null) return fallback;

    final parsed = value.toString().trim();
    return parsed.isEmpty ? fallback : parsed;
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString().trim() ?? '') ?? fallback;
  }

  static Color _parseColor(dynamic value, {required Color fallback}) {
    if (value is Color) return value;
    if (value is int) return Color(value);

    var colorValue = value?.toString().trim() ?? '';
    if (colorValue.isEmpty) return fallback;

    colorValue = colorValue
        .replaceFirst('#', '')
        .replaceFirst(RegExp(r'^0[xX]'), '');

    // API may send RRGGBB without an alpha channel.
    if (colorValue.length == 6) {
      colorValue = 'FF$colorValue';
    }

    if (colorValue.length != 8) return fallback;

    final parsedColor = int.tryParse(colorValue, radix: 16);
    return parsedColor == null ? fallback : Color(parsedColor);
  }
}

class CalendarState {
  final DateTime selectedDate;
  final List<EventModel> events;

  CalendarState({
    required this.selectedDate,
    List<EventModel> events = const [],
  }) : events = List<EventModel>.unmodifiable(events);

  factory CalendarState.fromJson(Map<String, dynamic> json) {
    return CalendarState(
      selectedDate: _parseDateTime(
        json['selectedDate'] ?? json['selected_date'],
        fallback: DateTime.now(),
      ),
      events: _parseEvents(json['events']),
    );
  }

  CalendarState copyWith({DateTime? selectedDate, List<EventModel>? events}) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      events: events ?? this.events,
    );
  }

  static DateTime _parseDateTime(dynamic value, {required DateTime fallback}) {
    if (value is DateTime) return value;

    if (value is int) {
      // Support timestamps sent in either seconds or milliseconds.
      final milliseconds = value.abs() < 100000000000 ? value * 1000 : value;

      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }

    if (value is num) {
      final timestamp = value.toInt();
      final milliseconds = timestamp.abs() < 100000000000
          ? timestamp * 1000
          : timestamp;

      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }

    final rawValue = value?.toString().trim();
    if (rawValue == null || rawValue.isEmpty) return fallback;

    return DateTime.tryParse(rawValue) ?? fallback;
  }

  static List<EventModel> _parseEvents(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((event) => EventModel.fromJson(Map<String, dynamic>.from(event)))
        .toList(growable: false);
  }
}
