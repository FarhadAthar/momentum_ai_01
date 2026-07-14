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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statsViewModelProvider);

    final List<PieChartSectionData> timeSplitSections =
        state.timeSplitSections.isNotEmpty
        ? state.timeSplitSections
        : _fallbackTimeSplitSections;

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            _buildHeader(),

            const SizedBox(height: 24),

            // Four analytics cards
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

                    // Important:
                    // Fixed safe card height removes bottom overflow.
                    mainAxisExtent: 176,
                  ),
                  children: [
                    _StatCard(
                      icon: Icons.check_box_rounded,
                      iconColor: const Color(0xFF10B981),
                      value: '${state.tasksCompleted}',
                      label: 'Tasks Completed',
                      trend: '+${state.tasksPercentIncrease}% week',
                      trendColor: const Color(0xFF10B981),
                    ),
                    _StatCard(
                      icon: Icons.timer_outlined,
                      iconColor: const Color(0xFF6366F1),
                      value: '${state.focusHours}h',
                      label: 'Focus Hours',
                      trend: '+${state.focusHoursPercentIncrease}% week',
                      trendColor: const Color(0xFF10B981),
                    ),
                    _StatCard(
                      icon: Icons.percent_rounded,
                      iconColor: const Color(0xFF6B7280),
                      value: '${state.completionRate}%',
                      label: 'Completion Rate',
                      trend: '${state.completionRatePercentChange}% week',
                      trendColor: const Color(0xFFEF4444),
                    ),
                    _StatCard(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      value: '${state.streak} days',
                      label: 'Streak',
                      trend: 'Personal best!',
                      trendColor: const Color(0xFF10B981),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            WeeklyFocusChart(data: state.focusHourSpots),

            const SizedBox(height: 16),

            // Productivity and Time Split charts
            LayoutBuilder(
              builder: (context, constraints) {
                final bool showVertically = constraints.maxWidth < 280;

                if (showVertically) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductivityScoreChart(values: state.productivityValues),
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
                        values: state.productivityValues,
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

            const _AICoachingCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                  color: const Color(0xFF9CA3AF),
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
                    color: const Color(0xFF111827),
                    letterSpacing: -0.6,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE9EDF5)),
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
                'Weekly',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF3), width: 1),
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
          // Icon box
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

          // Flexible empty space prevents overflow.
          const Spacer(),

          // Main value
          _ResponsiveCardText(
            text: value,
            height: 34,
            style: TextStyle(
              fontSize: 27,
              height: 1,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
              letterSpacing: -0.7,
            ),
          ),

          const SizedBox(height: 3),

          // Card label
          _ResponsiveCardText(
            text: label,
            height: 18,
            style: TextStyle(
              fontSize: 12,
              height: 1,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 8),

          // Trend text
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

/// Keeps every card text on one line and automatically scales it down.
///
/// Fixed height ensures that text scaling or longer values cannot produce
/// a RenderFlex bottom overflow.
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
  const _AICoachingCard();

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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Excellent week! Focus hours are up by 8%, with your '
            'best Tuesday yet. You have six recurring tasks delayed. '
            'Schedule them during your 2–3 PM low-energy window. '
            'Your work-life balance also needs attention.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.88),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          const Row(
            children: [
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
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
