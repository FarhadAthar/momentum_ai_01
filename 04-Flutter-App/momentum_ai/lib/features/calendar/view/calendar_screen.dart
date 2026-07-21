// lib/features/calendar/view/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:momentum_ai/features/calendar/model/calendar_state.dart';
import '../view_model/calendar_view_model.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarAsync = ref.watch(calendarViewModelProvider);

    return calendarAsync.when(
      data: (state) => _buildCalendar(context, ref, state),
      loading: () => _buildLoadingState(context),
      error: (error, _) => _buildErrorState(context, ref, error),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    WidgetRef ref,
    CalendarState state,
  ) {
    final notifier = ref.read(calendarViewModelProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Generate week days based on selected date
    final weekDays = List.generate(7, (index) {
      return state.selectedDate.subtract(Duration(days: 3 - index));
    });

    final monthYear = DateFormat('MMMM yyyy').format(state.selectedDate);
    final formattedDate = DateFormat('MMMM d').format(state.selectedDate);

    // 👇 FIX: Dynamic Status Bar & Navigation Bar style
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle(isDark),
      child: Scaffold(
        // 👇 FIX: Key add kiya taake IndexedStack theme switch par force rebuild kare
        key: const ValueKey('calendar_screen'),
        extendBody: true,
        // 👇 FIX: Background color Theme aware
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          systemOverlayStyle: _systemUiStyle(isDark),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            monthYear,
            // 👇 FIX: Dynamic title color
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              fontFamily: 'Manrope',
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
                    // 👇 FIX: Calendar heading dynamic color
                    Text(
                      'Calendar',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                    Row(
                      children: [
                        _IntegrationChip(label: 'Google', isDark: isDark),
                        const SizedBox(width: 8),
                        _IntegrationChip(label: 'Outlook', isDark: isDark),
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
                // 👇 FIX: Hardcoded white hata kar Theme.cardColor laga diya
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
                    final dayName = DateFormat(
                      'E',
                    ).format(date).substring(0, 3);
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
                                    : Theme.of(context).colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                fontFamily: 'Manrope',
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
                                    : (isDark
                                          ? Colors.white
                                          : const Color(0xFF111827)),
                                fontFamily: 'SpaceGrotesk',
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
                    // 👇 FIX: Dynamic events title color
                    Text(
                      '$formattedDate · Events',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontFamily: 'Manrope',
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
                      .map((event) => _EventCard(event: event, isDark: isDark))
                      .toList(),
                ),
              ),

              // --- 5. Empty State Placeholder ---
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // 👇 FIX: Dynamic empty state text colors
                      Text(
                        'No more events today',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontFamily: 'Manrope',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap + to add an event',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.4),
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle(isDark),
      child: Scaffold(
        key: const ValueKey('calendar_loading'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAsyncStateAppBar(context, isDark),
        body: const SafeArea(child: Center(child: CircularProgressIndicator())),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle(isDark),
      child: Scaffold(
        key: const ValueKey('calendar_error'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAsyncStateAppBar(context, isDark),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load calendar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontFamily: 'Manrope',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontFamily: 'Manrope',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      ref
                          .read(calendarViewModelProvider.notifier)
                          .fetchEvents();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAsyncStateAppBar(
    BuildContext context,
    bool isDark,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: _systemUiStyle(isDark),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          size: 20,
          color: isDark ? Colors.white : const Color(0xFF111827),
        ),
        onPressed: () => context.pop(),
      ),
    );
  }

  SystemUiOverlayStyle _systemUiStyle(bool isDark) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF3F4F6),
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }
}

// --- Helper Widgets ---

class _IntegrationChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _IntegrationChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      // 👇 FIX: Chip background theme aware
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        // 👇 FIX: Chip text theme aware
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : const Color(0xFF111827),
          fontFamily: 'Manrope',
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;
  final bool isDark;

  const _EventCard({required this.event, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      // 👇 FIX: Card background theme aware
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
          // Colored Stripe (kept as is)
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
                // 👇 FIX: Event title dynamic color
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontFamily: 'Manrope',
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
                    // 👇 FIX: Event details dynamic color
                    Text(
                      '${event.time} · ${event.duration}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontFamily: 'Manrope',
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.people_outline_rounded,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    // 👇 FIX: Event attendees dynamic color
                    Text(
                      '${event.attendees}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Play Icon Action (kept as is)
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
