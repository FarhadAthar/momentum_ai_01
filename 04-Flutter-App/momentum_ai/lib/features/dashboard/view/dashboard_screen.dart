import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:momentum_ai/app/router.dart';
import 'package:momentum_ai/features/ai_chat/view/chat_screen.dart';

import '../view_model/dashboard_view_model.dart';
import 'widgets/weather_card.dart';
import 'widgets/focus_score_card.dart';
import 'widgets/ai_coach_card.dart';
import 'widgets/weekly_progress_chart.dart';
import 'widgets/task_priority_card.dart';
import 'widgets/custom_bottom_nav.dart';

import '../../../features/tasks/view/tasks_screen.dart';
import '../../../features/stats/view/stats_screen.dart';
import '../../../features/focus/view/focus_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _navController;
  late final Animation<Offset> _navOffset;

  @override
  void initState() {
    super.initState();
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _navOffset = Tween<Offset>(begin: const Offset(0, 1.4), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _navController, curve: Curves.easeOutQuart),
        );
    _navController.forward();
  }

  @override
  void dispose() {
    _navController.dispose();
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

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop && _selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xFFF3F4F6),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              IndexedStack(
                index: _selectedIndex,
                children: [
                  // 0. Home Dashboard
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
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
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF9CA3AF),
                                      fontFamily: 'Manrope',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_getGreeting()},',
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                      fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${state.userName}!',
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF111827),
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
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
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
                                      child: const Center(
                                        child: Icon(
                                          Icons.notifications_none_rounded,
                                          color: Color(0xFF111827),
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
                        const SizedBox(height: 16),

                        // --- Upcoming Meetings ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Upcoming Meetings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF111827),
                                fontFamily: 'Manrope',
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push(AppRoutes.calendar),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Calendar',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4F46E5),
                                      fontFamily: 'Manrope',
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
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
                        ...state.meetings.map(
                          (meeting) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
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
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF6366F1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meeting.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF111827),
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
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
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF9CA3AF),
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
                                          Text(
                                            '${meeting.peopleCount} people',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF9CA3AF),
                                              fontFamily: 'Manrope',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // --- Premium Habit Tracker Card (Newly Added) ---
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.habits),
                          child: Container(
                            padding: const EdgeInsets.all(16),
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
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3E5F5),
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
                                    children: const [
                                      Text(
                                        'Habit Tracker',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF111827),
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        '3 of 4 habits done today',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B7280),
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Today's Priorities ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Today\'s Priorities',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF111827),
                                fontFamily: 'Manrope',
                              ),
                            ),
                            TextButton(
                              onPressed: _goToTasks,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'See all',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4F46E5),
                                      fontFamily: 'Manrope',
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
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

              // Custom Bottom Nav
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _navOffset,
                  child: CustomBottomNav(
                    selectedIndex: _selectedIndex,
                    onItemTapped: (index) {
                      if (_selectedIndex != index) {
                        setState(() => _selectedIndex = index);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
