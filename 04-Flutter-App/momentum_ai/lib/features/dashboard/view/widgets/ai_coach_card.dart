import 'package:flutter/material.dart';

class AICoachCard extends StatelessWidget {
  const AICoachCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // 👇 FIX: Dark mode mein soft dark colour, Light mode mein yellow
        color: isDark ? const Color(0xFF2D1B0E) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF4A2E1A) : const Color(0xFFFFE0B2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFF9800),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Productivity Coach',
                  style: TextStyle(
                    // 👇 Dynamic text color
                    color: isDark
                        ? const Color(0xFFFFD54F)
                        : const Color(0xFF4E342E),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You have 3 overdue tasks. Your peak focus is 9–11AM — deep work now before your standup!',
                  style: TextStyle(
                    // 👇 Dynamic text color
                    color: isDark
                        ? const Color(0xFFFFCC80)
                        : const Color(0xFF5D4037),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    fontFamily: 'Manrope',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
