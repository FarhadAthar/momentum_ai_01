import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
import '../../../features/stats/view/stats_screen.dart'; // Stats wala import bhi yahan hona chahiye
import '../../../features/focus/view/focus_screen.dart'; // Focus wala import bhi yahan hona chahiye

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardViewModelProvider);
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d · h:mm a').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // 👇 FIX: 5 Children rakh diye hain, ab crash nahi hoga
            IndexedStack(
              index: _selectedIndex,
              children: [
                // 0. Home Dashboard
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Good morning,',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${state.userName}!',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF111827),
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
                          SizedBox(
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
                                        style: GoogleFonts.manrope(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => context.push(
                              AppRoutes.profile,
                            ), // 👈 YEH LINE ADD KARI
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'A',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const WeatherCard(),
                      const SizedBox(height: 16),
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
                      const AICoachCard(),
                      const SizedBox(height: 16),
                      const WeeklyProgressChart(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upcoming Meetings',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Color(0xFF4F46E5),
                            ),
                            label: Text(
                              'Calendar',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meeting.title,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF111827),
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
                                          style: GoogleFonts.manrope(
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
                                          '${meeting.peopleCount} people',
                                          style: GoogleFonts.manrope(
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today\'s Priorities',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Color(0xFF4F46E5),
                            ),
                            label: Text(
                              'See all',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

                // 2. Focus Placeholder
                const FocusScreen(),

                // 3. Stats Placeholder
                const StatsScreen(),

                // 4. AI Placeholder
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
    );
  }
}
