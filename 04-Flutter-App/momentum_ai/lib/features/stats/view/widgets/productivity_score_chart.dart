import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProductivityScoreChart extends StatelessWidget {
  final List<double> values;

  const ProductivityScoreChart({super.key, required this.values});

  static const List<String> _categories = [
    'Focus',
    'Balance',
    'Energy',
    'Habits',
    'Goals',
    'Tasks',
  ];
  static const Color _primaryColor = Color(0xFF5B5FEF);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<double> safeValues = List.generate(_categories.length, (index) {
      if (index >= values.length) return 0;
      return values[index].clamp(0, 5).toDouble();
    }, growable: false);

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: AspectRatio(
          aspectRatio: 0.82,
          child: Container(
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            // 👇 FIX: Hardcoded white hata kar Theme.cardColor laga diya
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
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
                SizedBox(
                  width: double.infinity,
                  height: 18,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Productivity Score',
                      maxLines: 1,
                      // 👇 FIX: Dynamic title color
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double chartSize = math.min(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                      return Center(
                        child: SizedBox.square(
                          dimension: chartSize,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              RadarChart(
                                RadarChartData(
                                  radarTouchData: RadarTouchData(
                                    enabled: false,
                                  ),
                                  radarShape: RadarShape.polygon,
                                  radarBackgroundColor: Colors.transparent,
                                  borderData: FlBorderData(show: false),
                                  tickCount: 4,
                                  // 👇 Hide inner numbers
                                  ticksTextStyle: const TextStyle(
                                    color: Colors.transparent,
                                    fontSize: 0,
                                  ),
                                  tickBorderData: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withValues(alpha: 0.5),
                                    width: 0.8,
                                  ),
                                  gridBorderData: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withValues(alpha: 0.8),
                                    width: 0.9,
                                  ),
                                  radarBorderData: BorderSide(
                                    color: _primaryColor.withValues(
                                      alpha: 0.75,
                                    ),
                                    width: 1,
                                  ),
                                  titlePositionPercentageOffset: 0.16,
                                  // 👇 FIX: Dynamic label color
                                  titleTextStyle: TextStyle(
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.7)
                                        : const Color(0xFF8B93A1),
                                    height: 1,
                                  ),
                                  getTitle: (index, angle) =>
                                      RadarChartTitle(text: _categories[index]),
                                  dataSets: [
                                    _buildScaleDataSet(0),
                                    _buildScaleDataSet(5),
                                    RadarDataSet(
                                      dataEntries: safeValues
                                          .map((v) => RadarEntry(value: v))
                                          .toList(),
                                      fillColor: _primaryColor.withValues(
                                        alpha: 0.18,
                                      ),
                                      borderColor: _primaryColor,
                                      borderWidth: 2,
                                      entryRadius: 2,
                                    ),
                                  ],
                                ),
                                swapAnimationDuration: const Duration(
                                  milliseconds: 350,
                                ),
                                swapAnimationCurve: Curves.easeOutCubic,
                              ),
                              // 👇 FIX: Premium center dot background theme aware
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _primaryColor.withValues(
                                      alpha: 0.18,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryColor.withValues(
                                        alpha: 0.18,
                                      ),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
  }

  RadarDataSet _buildScaleDataSet(double value) {
    return RadarDataSet(
      dataEntries: List.generate(
        _categories.length,
        (_) => RadarEntry(value: value),
        growable: false,
      ),
      fillColor: Colors.transparent,
      borderColor: Colors.transparent,
      borderWidth: 0,
      entryRadius: 0,
    );
  }
}
