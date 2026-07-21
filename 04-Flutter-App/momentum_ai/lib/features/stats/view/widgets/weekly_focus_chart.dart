import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyFocusChart extends StatelessWidget {
  final List<FlSpot> data;

  const WeeklyFocusChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      // 👇 FIX: Hardcoded white hata kar Theme.cardColor laga diya
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Focus Hours This Week',
            // 👇 FIX: Dynamic title color
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 2.0,
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: false),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        final index = value.toInt();
                        if (index >= 0 && index < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              days[index],
                              // 👇 FIX: Dynamic labels color
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                                fontFamily: 'Manrope',
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    color: const Color(0xFF6366F1),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.25),
                          const Color(0xFF6366F1).withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: Theme.of(
                            context,
                          ).cardColor, // 👈 FIX: Dots theme aware
                          strokeWidth: 2,
                          strokeColor: const Color(0xFF6366F1),
                        );
                      },
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOutQuart,
            ),
          ),
        ],
      ),
    );
  }
}
