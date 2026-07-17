import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:momentum_ai/app/router.dart';
import 'package:momentum_ai/features/ai_chat/view/chat_screen.dart';

import '../view_model/dashboard_view_model.dart';
import '../model/dashboard_state.dart';
import 'widgets/weather_card.dart';
import 'widgets/focus_score_card.dart';
import 'widgets/ai_coach_card.dart';
import 'widgets/weekly_progress_chart.dart';
import 'widgets/task_priority_card.dart';

import '../../../features/tasks/view/tasks_screen.dart';
import '../../../features/stats/view/stats_screen.dart';
import '../../../features/focus/view/focus_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _goToStats() {
    if (_selectedIndex != 3) {
      setState(() {
        _selectedIndex = 3;
      });
    }
  }

  void _goToTasks() {
    if (_selectedIndex != 1) {
      setState(() {
        _selectedIndex = 1;
      });
    }
  }

  // Premium Feature: Dynamic Greeting based on time
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardViewModelProvider);
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d · h:mm a').format(now);

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF3F4F6),
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                IndexedStack(
                  index: _selectedIndex,
                  children: [
                    // 0. Home Dashboard
                    SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        16,
                        20,
                        85 + bottomInset,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Top Header ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.6),
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_getGreeting()},',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontFamily: 'SpaceGrotesk',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${state.userName}!',
                                          style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w900,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF111827),
                                            fontFamily: 'SpaceGrotesk',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          '👋',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // --- Notification Bell ---
                              GestureDetector(
                                onTap: () =>
                                    context.push(AppRoutes.notifications),
                                child: SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.06,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.notifications_none_rounded,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      if (state.notificationCount > 0)
                                        Positioned(
                                          right: -2,
                                          top: -2,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFEF4444),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '${state.notificationCount}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Manrope',
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // --- Profile Avatar ---
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.profile),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6366F1),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'A',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'SpaceGrotesk',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // --- Weather Card ---
                          const WeatherCard(),
                          const SizedBox(height: 16),

                          // --- Focus Score Card ---
                          FocusScoreCard(
                            score: state.dailyFocusScore,
                            increase: state.weeklyFocusIncrease,
                            tasksCompleted: state.tasksCompleted,
                            totalTasks: state.totalTasks,
                            focusHours: state.focusHours,
                            streak: state.streak,
                            xp: state.xp,
                          ),
                          const SizedBox(height: 16),

                          // --- AI Coach Card ---
                          const AICoachCard(),
                          const SizedBox(height: 16),

                          // --- Weekly Progress ---
                          WeeklyProgressChart(onFullReportTap: _goToStats),
                          const SizedBox(height: 24),

                          // --- Upcoming Meetings ---
                          _buildUpcomingMeetingsSection(state.meetings),
                          const SizedBox(height: 28),

                          // --- Premium Habit Tracker Card ---
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.habits),
                            child: Container(
                              padding: const EdgeInsets.all(16),
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
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF2D1B4E)
                                          : const Color(0xFFF3E5F5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.self_improvement_rounded,
                                      color: Color(0xFF6366F1),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Habit Tracker',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF111827),
                                            fontFamily: 'Manrope',
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '3 of 4 habits done today',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                            fontFamily: 'Manrope',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // --- Today's Priorities ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today\'s Priorities',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                  fontFamily: 'Manrope',
                                ),
                              ),
                              TextButton(
                                onPressed: _goToTasks,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'See all',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF4F46E5),
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 16,
                                      color: Color(0xFF4F46E5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...state.priorities.map(
                            (task) => TaskPriorityCard(task: task),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    // 1. Tasks Screen
                    const TasksScreen(),

                    // 2. Focus Screen
                    const FocusScreen(),

                    // 3. Stats Screen
                    const StatsScreen(),

                    // 4. AI Chat Screen
                    const ChatScreen(),
                  ],
                ),

                // --- Premium Simple Bottom Navigation Bar ---
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80 + bottomInset,
                    padding: EdgeInsets.only(top: 8, bottom: bottomInset),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.5),
                          width: 1.0,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NavItem(
                          index: 0,
                          icon: Icons.home_rounded,
                          label: 'Home',
                          selectedIndex: _selectedIndex,
                          onTap: (index) {
                            if (_selectedIndex != index) {
                              setState(() => _selectedIndex = index);
                            }
                          },
                        ),
                        _NavItem(
                          index: 1,
                          icon: Icons.checklist_rounded,
                          label: 'Tasks',
                          selectedIndex: _selectedIndex,
                          onTap: (index) {
                            if (_selectedIndex != index) {
                              setState(() => _selectedIndex = index);
                            }
                          },
                        ),
                        _NavItem(
                          index: 2,
                          icon: Icons.bolt_rounded,
                          label: 'Focus',
                          selectedIndex: _selectedIndex,
                          onTap: (index) {
                            if (_selectedIndex != index) {
                              setState(() => _selectedIndex = index);
                            }
                          },
                        ),
                        _NavItem(
                          index: 3,
                          icon: Icons.analytics_rounded,
                          label: 'Stats',
                          selectedIndex: _selectedIndex,
                          onTap: (index) {
                            if (_selectedIndex != index) {
                              setState(() => _selectedIndex = index);
                            }
                          },
                        ),
                        _NavItem(
                          index: 4,
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'AI',
                          selectedIndex: _selectedIndex,
                          onTap: (index) {
                            if (_selectedIndex != index) {
                              setState(() => _selectedIndex = index);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper: Meetings Section ---
  Widget _buildUpcomingMeetingsSection(List<MeetingModel> meetings) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Meetings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF111827),
                fontFamily: 'Manrope',
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.calendar),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  const Text(
                    'Calendar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4F46E5),
                      fontFamily: 'Manrope',
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Color(0xFF4F46E5),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (meetings.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: Text(
                'No upcoming meetings',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontFamily: 'Manrope',
                ),
              ),
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: meetings.asMap().entries.map((entry) {
              final meeting = entry.value;
              final widthFactor = meetings.length == 1 ? 1.0 : 0.48;
              return SizedBox(
                width: MediaQuery.of(context).size.width * widthFactor - 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6366F1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        meeting.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                          fontFamily: 'Manrope',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            meeting.time,
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline_rounded,
                            size: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${meeting.peopleCount} people',
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
              );
            }).toList(),
          ),
      ],
    );
  }
}

// --- Premium Simple Bottom Navigation Item ---
class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final int selectedIndex;
  final Function(int) onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;
    // 👇 FIX 1: 'isDark' variable hata diya gaya hai kyunki use nahi ho raha tha.

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOutQuart,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      )
                    : null,
                color: isSelected ? null : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(
                            0xFF6366F1,
                          ).withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                // 👇 FIX 2: .withOpacity ko .withValues(alpha: ...) mein badal diya
                color: isSelected
                    ? Colors.white
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              // 👇 FIX 2: .withOpacity ko .withValues(alpha: ...) mein badal diya
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                fontFamily: 'Manrope',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
