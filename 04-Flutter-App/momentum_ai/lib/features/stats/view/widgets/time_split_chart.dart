import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeSplitChart extends StatelessWidget {
  final List<PieChartSectionData> sections;

  const TimeSplitChart({super.key, required this.sections});

  // Legend labels same order mein honi chahiye
  // jis order mein sections pass kiye ja rahe hain.
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

  static const Color _titleColor = Color(0xFF111827);
  static const Color _labelColor = Color(0xFF667085);
  static const Color _borderColor = Color(0xFFE7EBF3);

  @override
  Widget build(BuildContext context) {
    final List<_TimeSplitItem> items = _prepareItems();

    final double total = items.fold<double>(
      0,
      (previousValue, item) => previousValue + item.value,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : 180;

        // Card unnecessarily wide nahi hoga.
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
              // Provided design jaisa tall card.
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isCompact ? 16 : 18),
                  border: Border.all(color: _borderColor, width: 1),
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
                    _buildTitle(isCompact),

                    SizedBox(height: isCompact ? 6 : 8),

                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, contentConstraints) {
                          return _buildContent(
                            constraints: contentConstraints,
                            items: items,
                            total: total,
                            isCompact: isCompact,
                            isVerySmall: isVerySmall,
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

  Widget _buildTitle(bool isCompact) {
    return SizedBox(
      width: double.infinity,
      height: isCompact ? 17 : 19,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          'Time Split',
          maxLines: 1,
          style: GoogleFonts.manrope(
            fontSize: isCompact ? 12 : 13,
            fontWeight: FontWeight.w800,
            color: _titleColor,
            letterSpacing: -0.25,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BoxConstraints constraints,
    required List<_TimeSplitItem> items,
    required double total,
    required bool isCompact,
    required bool isVerySmall,
  }) {
    /*
     * Chart ko card ke upper center mein rakha gaya hai.
     * Neeche remaining space legend use karegi.
     */
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
          ),
        ),
      ],
    );
  }

  Widget _buildDonutChart({
    required List<_TimeSplitItem> items,
    required double total,
    required double chartSize,
  }) {
    return PieChart(
      PieChartData(
        sections: items
            .map((item) {
              /*
           * Agar sab values zero hain to chart disappear na ho.
           * Visual section equal show hogi, percentage phir bhi 0% rahega.
           */
              final double visualValue = total <= 0 ? 1 : item.value;

              return PieChartSectionData(
                value: visualValue,
                color: item.color,
                showTitle: false,

                // Donut ki premium balanced thickness.
                radius: chartSize * 0.155,
              );
            })
            .toList(growable: false),

        sectionsSpace: 0,

        // Chart top se start hoga.
        startDegreeOffset: -90,

        // Donut center hole.
        centerSpaceRadius: chartSize * 0.285,
        centerSpaceColor: Colors.white,

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
            );
          })
          .toList(growable: false),
    );
  }

  List<_TimeSplitItem> _prepareItems() {
    return List.generate(_labels.length, (index) {
      if (index < sections.length) {
        final PieChartSectionData section = sections[index];

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
    if (total <= 0) {
      return '0%';
    }

    final int result = ((value / total) * 100).round();

    return '$result%';
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final Color color;
  final String percentage;
  final bool isCompact;
  final bool isVerySmall;

  const _LegendRow({
    required this.label,
    required this.color,
    required this.percentage,
    required this.isCompact,
    required this.isVerySmall,
  });

  @override
  Widget build(BuildContext context) {
    final double dotSize = isVerySmall ? 5 : 6;
    final double fontSize = isVerySmall
        ? 7.5
        : isCompact
        ? 8.5
        : 9;

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
              style: GoogleFonts.manrope(
                fontSize: fontSize,
                height: 1,
                fontWeight: FontWeight.w600,
                color: TimeSplitChart._labelColor,
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
                style: GoogleFonts.manrope(
                  fontSize: fontSize,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: TimeSplitChart._titleColor,
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
