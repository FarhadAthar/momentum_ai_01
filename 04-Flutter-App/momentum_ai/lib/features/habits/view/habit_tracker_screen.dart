import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_model/habit_view_model.dart';
import '../model/habit_model.dart';

class HabitTrackerScreen extends ConsumerWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return habitsAsync.when(
      data: (state) {
        final notifier = ref.read(habitViewModelProvider.notifier);

        return _buildDataState(context, state, notifier, isDark);
      },
      loading: () => _buildLoadingState(context, isDark),
      error: (error, _) => _buildErrorState(context, ref, error, isDark),
    );
  }

  Widget _buildDataState(
    BuildContext context,
    HabitsState state,
    HabitViewModel notifier,
    bool isDark,
  ) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle(isDark),
      child: Scaffold(
        key: const ValueKey('habit_tracker_screen'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context, isDark),
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            children: [
              // --- Weekly Score Card ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'WEEKLY SCORE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white70,
                            fontFamily: 'Manrope',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Best: ${state.bestStreak} days',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${state.weeklyScore}%',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'SpaceGrotesk',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${state.habitsThisWeek} habits this week',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Week Days Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                          .asMap()
                          .entries
                          .map((entry) {
                            final int index = entry.key;
                            final String day = entry.value;
                            final bool isDone = index < 4;
                            return Column(
                              children: [
                                Text(
                                  day,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70,
                                    fontFamily: 'Manrope',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Icon(
                                  isDone
                                      ? Icons.check_circle_rounded
                                      : Icons.circle_rounded,
                                  size: 16,
                                  color: isDone
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.3),
                                ),
                              ],
                            );
                          })
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- AI Coach Card ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2D1B0E)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF4A2E1A)
                        : const Color(0xFFFFE0B2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF4B5563),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.smart_toy_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Amazing! You've maintained your workout streak for 14 days. Just 2 habits left today — you've got this! 💪",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFFFD54F)
                              : const Color(0xFF4E342E),
                          fontFamily: 'Manrope',
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Habit List ---
              ...state.habits.map(
                (habit) => _HabitCard(
                  habit: habit,
                  onToggle: () => notifier.toggleHabit(habit.id),
                  isDark: isDark,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isDark) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle(isDark),
      child: Scaffold(
        key: const ValueKey('habit_tracker_loading'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context, isDark),
        body: const SafeArea(
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF6366F1)),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    Object error,
    bool isDark,
  ) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle(isDark),
      child: Scaffold(
        key: const ValueKey('habit_tracker_error'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context, isDark),
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
                    'Unable to load habits',
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
                      ref.invalidate(habitViewModelProvider);
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

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
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
      title: Text(
        'Habit Tracker',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : const Color(0xFF111827),
          fontFamily: 'SpaceGrotesk',
        ),
      ),
      centerTitle: false,
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
    );
  }
}

// --- Custom Habit Card Widget ---
class _HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback onToggle;
  final bool isDark;

  const _HabitCard({
    required this.habit,
    required this.onToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
        children: [
          // Left Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: habit.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              habit.icon,
              color: isDark ? Colors.white : const Color(0xFF111827),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Middle Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      habit.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontFamily: 'Manrope',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E1233)
                            : const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        habit.tag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? const Color(0xFFA78BFA)
                              : const Color(0xFF6D28D9),
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: habit.progress,
                    minHeight: 6,
                    backgroundColor: isDark
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFFF3F4F6),
                    color: habit.progress > 0.6
                        ? const Color(0xFF10B981)
                        : const Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 14,
                      color: Color(0xFFF97316),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${habit.streak} day streak',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontFamily: 'Manrope',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${habit.currentCount}/${habit.targetCount}d',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
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
          const SizedBox(width: 12),

          // Right Toggle Button
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutQuart,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: habit.isCompletedToday
                    ? const Color(0xFF10B981)
                    : isDark
                    ? Theme.of(context).cardColor
                    : const Color(0xFFF3F4F6),
                border: Border.all(
                  color: habit.isCompletedToday
                      ? const Color(0xFF10B981)
                      : isDark
                      ? Theme.of(context).dividerColor.withValues(alpha: 0.5)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: AnimatedScale(
                scale: habit.isCompletedToday ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
