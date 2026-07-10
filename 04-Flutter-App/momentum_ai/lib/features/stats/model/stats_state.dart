// lib/features/stats/model/stats_state.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsState {
  final int tasksCompleted;
  final int tasksPercentIncrease; // +12
  final double focusHours;
  final int focusHoursPercentIncrease; // +8
  final int completionRate;
  final int completionRatePercentChange; // -3
  final int streak;
  final bool isPersonalBest;

  // Chart 1: Line Chart Data
  final List<FlSpot> focusHourSpots;

  // Chart 2: Radar Chart Data
  final List<double> productivityValues;

  // Chart 3: Pie Chart Data
  final List<PieChartSectionData> timeSplitSections;

  const StatsState({
    this.tasksCompleted = 94,
    this.tasksPercentIncrease = 12,
    this.focusHours = 35.5,
    this.focusHoursPercentIncrease = 8,
    this.completionRate = 87,
    this.completionRatePercentChange = -3,
    this.streak = 12,
    this.isPersonalBest = true,
    this.focusHourSpots = const [
      FlSpot(0, 3.5), // Mon
      FlSpot(1, 5.2), // Tue
      FlSpot(2, 4.0), // Wed
      FlSpot(3, 4.8), // Thu
      FlSpot(4, 6.1), // Fri
      FlSpot(5, 2.8), // Sat
      FlSpot(6, 4.2), // Sun
    ],
    this.productivityValues = const [
      3.5,
      4.0,
      2.5,
      4.5,
      3.0,
      3.8,
    ], // Focus, Balance, Energy, Habits, Goals, Tasks
    this.timeSplitSections = const [],
  });

  StatsState copyWith({
    int? tasksCompleted,
    int? tasksPercentIncrease,
    double? focusHours,
    int? focusHoursPercentIncrease,
    int? completionRate,
    int? completionRatePercentChange,
    int? streak,
    bool? isPersonalBest,
    List<FlSpot>? focusHourSpots,
    List<double>? productivityValues,
    List<PieChartSectionData>? timeSplitSections,
  }) {
    return StatsState(
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      tasksPercentIncrease: tasksPercentIncrease ?? this.tasksPercentIncrease,
      focusHours: focusHours ?? this.focusHours,
      focusHoursPercentIncrease:
          focusHoursPercentIncrease ?? this.focusHoursPercentIncrease,
      completionRate: completionRate ?? this.completionRate,
      completionRatePercentChange:
          completionRatePercentChange ?? this.completionRatePercentChange,
      streak: streak ?? this.streak,
      isPersonalBest: isPersonalBest ?? this.isPersonalBest,
      focusHourSpots: focusHourSpots ?? this.focusHourSpots,
      productivityValues: productivityValues ?? this.productivityValues,
      timeSplitSections: timeSplitSections ?? _getDefaultPieSections(),
    );
  }

  List<PieChartSectionData> _getDefaultPieSections() {
    return [
      PieChartSectionData(
        color: const Color(0xFF6366F1), // Work 45%
        value: 45,
        radius: 25,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFF8B5CF6), // Meetings 20%
        value: 20,
        radius: 25,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFF06B6D4), // Learning 20%
        value: 20,
        radius: 25,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFF10B981), // Personal 15%
        value: 15,
        radius: 25,
        showTitle: false,
      ),
    ];
  }
}
