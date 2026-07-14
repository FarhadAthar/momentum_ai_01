// lib/features/calendar/view/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
import 'package:momentum_ai/features/calendar/model/calendar_state.dart';
import '../view_model/calendar_view_model.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarViewModelProvider);
    final notifier = ref.read(calendarViewModelProvider.notifier);

    // Generate week days based on selected date
    final weekDays = List.generate(7, (index) {
      return state.selectedDate.subtract(Duration(days: 3 - index));
    });

    final monthYear = DateFormat('MMMM yyyy').format(state.selectedDate);
    final formattedDate = DateFormat('MMMM d').format(state.selectedDate);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 20,
            color: Color(0xFF111827),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          monthYear,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF9CA3AF),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Calendar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  Row(
                    children: [
                      _IntegrationChip(label: 'Google'),
                      const SizedBox(width: 8),
                      _IntegrationChip(label: 'Outlook'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- 2. Week Strip ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: weekDays.map((date) {
                  final isSelected = DateUtils.isSameDay(
                    date,
                    state.selectedDate,
                  );
                  final dayNum = DateFormat('d').format(date);
                  final dayName = DateFormat('E').format(date).substring(0, 3);
                  return GestureDetector(
                    onTap: () => notifier.selectDate(date),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6366F1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dayNum,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF111827),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(height: 2),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ] else if (date.day % 2 == 0) ...[
                            const SizedBox(height: 2),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6366F1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. Events List ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$formattedDate · Events',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- 4. Event Cards ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                children: state.events
                    .map((event) => _EventCard(event: event))
                    .toList(),
              ),
            ),

            // --- 5. Empty State Placeholder ---
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Text(
                      'No more events today',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    Text(
                      'Tap + to add an event',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFD1D5DB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

class _IntegrationChip extends StatelessWidget {
  final String label;
  const _IntegrationChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF111827),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored Stripe
          Container(
            width: 4,
            height: 45,
            decoration: BoxDecoration(
              color: event.stripeColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${event.time} · ${event.duration}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.people_outline_rounded,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${event.attendees}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Play Icon Action
          const Icon(
            Icons.play_circle_outline_rounded,
            size: 24,
            color: Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }
}
