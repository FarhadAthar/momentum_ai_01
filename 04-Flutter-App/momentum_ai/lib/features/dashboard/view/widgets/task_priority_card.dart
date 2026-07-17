import 'package:flutter/material.dart';
import '../../model/dashboard_state.dart';

class TaskPriorityCard extends StatelessWidget {
  final TaskPriorityModel task;

  const TaskPriorityCard({super.key, required this.task});

  Color _getPriorityColor(String type) {
    switch (type) {
      case 'urgent':
        return const Color(0xFF8B5CF6);
      case 'finance':
        return const Color(0xFF6366F1);
      case 'meeting':
        return const Color(0xFF14B8A6);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  Color _getTagColor(String tag, bool isDark) {
    if (tag == 'URGENT') {
      return isDark ? const Color(0xFF4A1A1A) : const Color(0xFFFEE2E2);
    }
    if (tag == 'Work') {
      return isDark ? const Color(0xFF1E1233) : const Color(0xFFEDE9FE);
    }
    if (tag == 'Finance') {
      return isDark ? const Color(0xFF12264A) : const Color(0xFFDBEAFE);
    }
    if (tag == 'Meeting') {
      return isDark ? const Color(0xFF12363F) : const Color(0xFFE0F2FE);
    }
    return Colors.grey.shade200;
  }

  Color _getTagTextColor(String tag, bool isDark) {
    if (tag == 'URGENT') {
      return isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
    }
    if (tag == 'Work') {
      return isDark ? const Color(0xFFA78BFA) : const Color(0xFF6D28D9);
    }
    if (tag == 'Finance') {
      return isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    }
    if (tag == 'Meeting') {
      return isDark ? const Color(0xFF22D3EE) : const Color(0xFF0284C7);
    }
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      // 👇 FIX: Hardcoded white ko Theme.cardColor mein badal diya
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _getPriorityColor(task.type),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  children: task.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTagColor(tag, isDark),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: _getTagTextColor(tag, isDark),
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 6),
                Text(
                  task.title,
                  // 👇 FIX: Dynamic title color
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.timeEstimate,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_horiz_rounded,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}
