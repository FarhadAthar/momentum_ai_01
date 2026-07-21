import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TimeSplitChart extends StatelessWidget {
  final List<PieChartSectionData> sections;

  const TimeSplitChart({super.key, required this.sections});

  static const List<String> _labels = [
    'Work',
    'Meetings',
    'Learning',
    'Personal',
  ];
  static const List<Color> _defaultColors = [
    Color(0xFF5B5FEF),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFF10B981),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<_TimeSplitItem> items = _prepareItems();
    final double total = items.fold<double>(
      0,
      (prev, item) => prev + item.value,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : 180;
        final double cardWidth = math.min(availableWidth, 220);
        final bool isVerySmall = cardWidth < 145;
        final bool isCompact = cardWidth < 180;
        final double horizontalPadding = isVerySmall ? 10 : 12;
        final double verticalPadding = isVerySmall ? 10 : 12;

        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: cardWidth,
            child: AspectRatio(
              aspectRatio: 0.82,
              child: Container(
                clipBehavior: Clip.antiAlias,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalPadding,
                  horizontalPadding,
                  verticalPadding,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(isCompact ? 16 : 18),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.045),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.025),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(isCompact, isDark),
                    SizedBox(height: isCompact ? 6 : 8),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, contentConstraints) {
                          // 👇 FIX: 'context' ko yahan se pass kiya
                          return _buildContent(
                            constraints: contentConstraints,
                            items: items,
                            total: total,
                            isCompact: isCompact,
                            isVerySmall: isVerySmall,
                            isDark: isDark,
                            context: context,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(bool isCompact, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: isCompact ? 17 : 19,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          'Time Split',
          maxLines: 1,
          style: TextStyle(
            fontSize: isCompact ? 12 : 13,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF111827),
            letterSpacing: -0.25,
            height: 1,
          ),
        ),
      ),
    );
  }

  // 👇 FIX: 'required BuildContext context' yahan add kar diya
  Widget _buildContent({
    required BoxConstraints constraints,
    required List<_TimeSplitItem> items,
    required double total,
    required bool isCompact,
    required bool isVerySmall,
    required bool isDark,
    required BuildContext context,
  }) {
    final double chartSize = math.min(
      constraints.maxWidth * (isCompact ? 0.53 : 0.56),
      constraints.maxHeight * 0.49,
    );
    final double safeChartSize = chartSize.clamp(
      isVerySmall ? 48.0 : 58.0,
      94.0,
    );

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: SizedBox.square(
              dimension: safeChartSize,
              child: _buildDonutChart(
                items: items,
                total: total,
                chartSize: safeChartSize,
                isDark: isDark,
                context:
                    context, // 👈 Ab 'context' valid hai aur yahan pass ho raha hai
              ),
            ),
          ),
        ),
        SizedBox(height: isCompact ? 3 : 5),
        Expanded(
          flex: 4,
          child: _buildLegend(
            items: items,
            total: total,
            isCompact: isCompact,
            isVerySmall: isVerySmall,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildDonutChart({
    required List<_TimeSplitItem> items,
    required double total,
    required double chartSize,
    required bool isDark,
    required BuildContext context,
  }) {
    return PieChart(
      PieChartData(
        sections: items
            .map((item) {
              final double visualValue = total <= 0 ? 1 : item.value;
              return PieChartSectionData(
                value: visualValue,
                color: item.color,
                showTitle: false,
                radius: chartSize * 0.155,
              );
            })
            .toList(growable: false),
        sectionsSpace: 0,
        startDegreeOffset: -90,
        centerSpaceRadius: chartSize * 0.285,
        centerSpaceColor: Theme.of(context).cardColor,
        borderData: FlBorderData(show: false),
        pieTouchData: PieTouchData(enabled: false),
      ),
      swapAnimationDuration: const Duration(milliseconds: 400),
      swapAnimationCurve: Curves.easeOutCubic,
    );
  }

  Widget _buildLegend({
    required List<_TimeSplitItem> items,
    required double total,
    required bool isCompact,
    required bool isVerySmall,
    required bool isDark,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items
          .map((item) {
            return _LegendRow(
              label: item.label,
              color: item.color,
              percentage: _percentage(item.value, total),
              isCompact: isCompact,
              isVerySmall: isVerySmall,
              isDark: isDark,
            );
          })
          .toList(growable: false),
    );
  }

  List<_TimeSplitItem> _prepareItems() {
    return List.generate(_labels.length, (index) {
      if (index < sections.length) {
        final section = sections[index];
        final double safeValue = section.value.isFinite && section.value > 0
            ? section.value
            : 0;
        return _TimeSplitItem(
          label: _labels[index],
          value: safeValue,
          color: section.color,
        );
      }
      return _TimeSplitItem(
        label: _labels[index],
        value: 0,
        color: _defaultColors[index],
      );
    }, growable: false);
  }

  String _percentage(double value, double total) {
    if (total <= 0) return '0%';
    return '${((value / total) * 100).round()}%';
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final Color color;
  final String percentage;
  final bool isCompact;
  final bool isVerySmall;
  final bool isDark;

  const _LegendRow({
    required this.label,
    required this.color,
    required this.percentage,
    required this.isCompact,
    required this.isVerySmall,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final double dotSize = isVerySmall ? 5 : 6;
    final double fontSize = isVerySmall ? 7.5 : (isCompact ? 8.5 : 9);

    return SizedBox(
      height: isVerySmall ? 13 : 15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.22),
                  blurRadius: 4,
                  spreadRadius: 0.3,
                ),
              ],
            ),
          ),
          SizedBox(width: isVerySmall ? 4 : 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                height: 1,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : const Color(0xFF667085),
              ),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: isVerySmall ? 27 : 32,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                percentage,
                maxLines: 1,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: fontSize,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSplitItem {
  final String label;
  final double value;
  final Color color;
  const _TimeSplitItem({
    required this.label,
    required this.value,
    required this.color,
  });
}
