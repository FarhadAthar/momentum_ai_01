import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsState {
  final int tasksCompleted;
  final int tasksPercentIncrease;
  final double focusHours;
  final int focusHoursPercentIncrease;
  final int completionRate;
  final int completionRatePercentChange;
  final int streak;
  final bool isPersonalBest;
  final List<FlSpot> focusHourSpots;
  final List<double> productivityValues;
  final List<PieChartSectionData> timeSplitSections;
  final String selectedTimeframe;

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
      FlSpot(0, 3.5),
      FlSpot(1, 5.2),
      FlSpot(2, 4.0),
      FlSpot(3, 4.8),
      FlSpot(4, 6.1),
      FlSpot(5, 2.8),
      FlSpot(6, 4.2),
    ],
    this.productivityValues = const [3.5, 4.0, 2.5, 4.5, 3.0, 3.8],
    this.timeSplitSections = const [],
    this.selectedTimeframe = 'Weekly',
  });

  // 👇 BACKEND API SE DATA AANE PAR MAP KARNE KE LIYE
  factory StatsState.fromJson(Map<String, dynamic> json) {
    // Implement actual parsing of FlSpot, PieChartSectionData etc. from API response later.
    return StatsState(
      tasksCompleted: json['tasksCompleted'] ?? 94,
      tasksPercentIncrease: json['tasksPercentIncrease'] ?? 12,
      focusHours: (json['focusHours'] ?? 35.5).toDouble(),
      focusHoursPercentIncrease: json['focusHoursPercentIncrease'] ?? 8,
      completionRate: json['completionRate'] ?? 87,
      completionRatePercentChange: json['completionRatePercentChange'] ?? -3,
      streak: json['streak'] ?? 12,
      isPersonalBest: json['isPersonalBest'] ?? true,
      selectedTimeframe: json['selectedTimeframe'] ?? 'Weekly',
    );
  }

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
    String? selectedTimeframe,
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
      selectedTimeframe: selectedTimeframe ?? this.selectedTimeframe,
    );
  }

  List<PieChartSectionData> _getDefaultPieSections() {
    return [
      PieChartSectionData(
        color: const Color(0xFF6366F1),
        value: 45,
        radius: 25,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFF8B5CF6),
        value: 20,
        radius: 25,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFF06B6D4),
        value: 20,
        radius: 25,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFF10B981),
        value: 15,
        radius: 25,
        showTitle: false,
      ),
    ];
  }
}
