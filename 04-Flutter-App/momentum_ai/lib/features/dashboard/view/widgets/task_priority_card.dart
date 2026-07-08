import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Color _getTagColor(String tag) {
    if (tag == 'URGENT') return const Color(0xFFFEE2E2);
    if (tag == 'Work') return const Color(0xFFEDE9FE);
    if (tag == 'Finance') return const Color(0xFFDBEAFE);
    if (tag == 'Meeting') return const Color(0xFFE0F2FE);
    return Colors.grey.shade200;
  }

  Color _getTagTextColor(String tag) {
    if (tag == 'URGENT') return const Color(0xFFDC2626);
    if (tag == 'Work') return const Color(0xFF6D28D9);
    if (tag == 'Finance') return const Color(0xFF2563EB);
    if (tag == 'Meeting') return const Color(0xFF0284C7);
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
                            color: _getTagColor(tag),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: _getTagTextColor(tag),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 6),
                Text(
                  task.title,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
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
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_horiz_rounded, color: Color(0xFFD1D5DB)),
        ],
      ),
    );
  }
}
