import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/stats_view_model.dart';
import 'widgets/productivity_score_chart.dart';
import 'widgets/time_split_chart.dart';
import 'widgets/weekly_focus_chart.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  static final List<PieChartSectionData> _fallbackTimeSplitSections = [
    PieChartSectionData(
      value: 45,
      color: const Color(0xFF5B5FEF),
      showTitle: false,
    ),
    PieChartSectionData(
      value: 20,
      color: const Color(0xFF8B5CF6),
      showTitle: false,
    ),
    PieChartSectionData(
      value: 20,
      color: const Color(0xFF06B6D4),
      showTitle: false,
    ),
    PieChartSectionData(
      value: 15,
      color: const Color(0xFF10B981),
      showTitle: false,
    ),
  ];

  void _showTimeframeSheet(BuildContext context, String currentTimeframe) {
    final List<String> options = ['Weekly', 'Monthly', 'Yearly'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Timeframe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...options.map((option) {
                    final bool isSelected = currentTimeframe == option;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          ref
                              .read(statsViewModelProvider.notifier)
                              .setTimeframe(option);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                      ? const Color(0xFF2D1B4E)
                                      : const Color(0xFFEDE9FE))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF6366F1)
                                      : (isDark
                                            ? Colors.white
                                            : const Color(0xFF111827)),
                                  fontFamily: 'Manrope',
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF6366F1),
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(statsViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      key: const ValueKey('stats_screen'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        // 👇 PRODUCTION-GRADE ASYNC HANDLING
        child: statsAsync.when(
          data: (stats) {
            final List<PieChartSectionData> timeSplitSections =
                stats.timeSplitSections.isNotEmpty
                ? stats.timeSplitSections
                : _fallbackTimeSplitSections;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                _buildHeader(stats.selectedTimeframe, isDark),
                const SizedBox(height: 24),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool useSingleColumn = constraints.maxWidth < 280;
                    return GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: useSingleColumn ? 1 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 176,
                      ),
                      children: [
                        _StatCard(
                          icon: Icons.check_box_rounded,
                          iconColor: const Color(0xFF10B981),
                          value: '${stats.tasksCompleted}',
                          label: 'Tasks Completed',
                          trend: '+${stats.tasksPercentIncrease}% week',
                          trendColor: const Color(0xFF10B981),
                        ),
                        _StatCard(
                          icon: Icons.timer_outlined,
                          iconColor: const Color(0xFF6366F1),
                          value: '${stats.focusHours}h',
                          label: 'Focus Hours',
                          trend: '+${stats.focusHoursPercentIncrease}% week',
                          trendColor: const Color(0xFF10B981),
                        ),
                        _StatCard(
                          icon: Icons.percent_rounded,
                          iconColor: const Color(0xFF6B7280),
                          value: '${stats.completionRate}%',
                          label: 'Completion Rate',
                          trend: '${stats.completionRatePercentChange}% week',
                          trendColor: const Color(0xFFEF4444),
                        ),
                        _StatCard(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          value: '${stats.streak} days',
                          label: 'Streak',
                          trend: 'Personal best!',
                          trendColor: const Color(0xFF10B981),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),
                WeeklyFocusChart(data: stats.focusHourSpots),
                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool showVertically = constraints.maxWidth < 280;
                    if (showVertically) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductivityScoreChart(
                            values: stats.productivityValues,
                          ),
                          const SizedBox(height: 12),
                          TimeSplitChart(sections: timeSplitSections),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ProductivityScoreChart(
                            values: stats.productivityValues,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TimeSplitChart(sections: timeSplitSections),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),
                _AICoachingCard(isDark: isDark),
                const SizedBox(height: 20),
              ],
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFEF4444),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading stats',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontFamily: 'Manrope',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontFamily: 'Manrope',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(String selectedTimeframe, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'July 2025 • Week 2',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Analytics',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    letterSpacing: -0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () => _showTimeframeSheet(context, selectedTimeframe),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedTimeframe,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: Color(0xFF6B7280),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String trend;
  final Color trendColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.trend,
    required this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: iconColor.withValues(alpha: 0.025),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const Spacer(),
          _ResponsiveCardText(
            text: value,
            height: 34,
            style: TextStyle(
              fontSize: 27,
              height: 1,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 3),
          _ResponsiveCardText(
            text: label,
            height: 18,
            style: TextStyle(
              fontSize: 12,
              height: 1,
              fontWeight: FontWeight.w700,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          _ResponsiveCardText(
            text: trend,
            height: 16,
            style: TextStyle(
              fontSize: 11,
              height: 1,
              fontWeight: FontWeight.w800,
              color: trendColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveCardText extends StatelessWidget {
  final String text;
  final double height;
  final TextStyle style;
  const _ResponsiveCardText({
    required this.text,
    required this.height,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: style,
        ),
      ),
    );
  }
}

class _AICoachingCard extends StatelessWidget {
  final bool isDark;
  const _AICoachingCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Weekly Coaching',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Excellent week! Focus hours are up by 8%, with your best Tuesday yet. You have six recurring tasks delayed. Schedule them during your 2–3 PM low-energy window. Your work-life balance also needs attention.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              _AICoachingChip(icon: '💪', title: 'Focus', subtitle: 'Strength'),
              SizedBox(width: 8),
              _AICoachingChip(
                icon: '🧘',
                title: 'Balance',
                subtitle: 'Improve',
              ),
              SizedBox(width: 8),
              _AICoachingChip(
                icon: '🔥',
                title: 'Habits',
                subtitle: 'Next week',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AICoachingChip extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  const _AICoachingChip({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 2),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
