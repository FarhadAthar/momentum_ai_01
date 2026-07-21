// lib/features/calendar/view_model/calendar_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_service.dart';
import '../model/calendar_state.dart';

final calendarViewModelProvider =
    AsyncNotifierProvider<CalendarViewModel, CalendarState>(
      CalendarViewModel.new,
    );

class CalendarViewModel extends AsyncNotifier<CalendarState> {
  @override
  Future<CalendarState> build() {
    return _loadCalendar();
  }

  Future<CalendarState> _loadCalendar({DateTime? selectedDate}) async {
    final rawList = await ApiService.getEvents();

    final events = rawList
        .map(
          (event) =>
              EventModel.fromJson(Map<String, dynamic>.from(event as Map)),
        )
        .toList(growable: false);

    return CalendarState(
      selectedDate: selectedDate ?? DateTime.now(),
      events: events,
    );
  }

  void selectDate(DateTime date) {
    state = state.whenData(
      (currentState) => currentState.copyWith(selectedDate: date),
    );
  }

  Future<void> fetchEvents() async {
    // `asData?.value` is compatible with Riverpod versions where
    // `valueOrNull` is unavailable.
    final selectedDate = state.asData?.value.selectedDate ?? DateTime.now();

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () => _loadCalendar(selectedDate: selectedDate),
    );
  }
}
