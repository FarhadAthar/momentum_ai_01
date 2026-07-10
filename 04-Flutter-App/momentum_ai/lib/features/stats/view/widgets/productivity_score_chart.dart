import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static const Color _titleColor = Color(0xFF111827);
  static const Color _labelColor = Color(0xFF8B93A1);
  static const Color _gridColor = Color(0xFFDDE3EE);

  @override
  Widget build(BuildContext context) {
    final List<double> safeValues = List.generate(_categories.length, (index) {
      if (index >= values.length) {
        return 0;
      }

      return values[index].clamp(0, 5).toDouble();
    }, growable: false);

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: AspectRatio(
          // Card ko screenshot jaisi compact height deta hai.
          aspectRatio: 0.82,
          child: Container(
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE9EDF5), width: 1),
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
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _titleColor,
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

                                  // Grid levels.
                                  tickCount: 4,

                                  // 1.0, 2.0, 3.0 values hide ki gayi hain.
                                  ticksTextStyle: const TextStyle(
                                    color: Colors.transparent,
                                    fontSize: 0,
                                  ),

                                  tickBorderData: BorderSide(
                                    color: _gridColor.withValues(alpha: 0.85),
                                    width: 0.8,
                                  ),
                                  gridBorderData: BorderSide(
                                    color: _gridColor,
                                    width: 0.9,
                                  ),
                                  radarBorderData: BorderSide(
                                    color: _primaryColor.withValues(
                                      alpha: 0.75,
                                    ),
                                    width: 1,
                                  ),
                                  titlePositionPercentageOffset: 0.16,
                                  titleTextStyle: GoogleFonts.manrope(
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w600,
                                    color: _labelColor,
                                    height: 1,
                                  ),
                                  getTitle: (index, angle) {
                                    return RadarChartTitle(
                                      text: _categories[index],
                                    );
                                  },
                                  dataSets: [
                                    // Invisible dataset scale ko 0 se 5 rakhta hai.
                                    _buildScaleDataSet(0),
                                    _buildScaleDataSet(5),

                                    // Actual productivity data.
                                    RadarDataSet(
                                      dataEntries: safeValues
                                          .map(
                                            (value) => RadarEntry(value: value),
                                          )
                                          .toList(growable: false),
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

                              // Premium center dot.
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
