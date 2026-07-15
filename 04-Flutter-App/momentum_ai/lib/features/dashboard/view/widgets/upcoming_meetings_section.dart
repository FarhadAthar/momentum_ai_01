import 'package:flutter/material.dart';
import 'package:momentum_ai/features/dashboard/model/dashboard_state.dart';

class UpcomingMeetingsSection extends StatelessWidget {
  final List<MeetingModel> meetings;
  final VoidCallback onCalendarTap;

  const UpcomingMeetingsSection({
    super.key,
    required this.meetings,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Meetings',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                fontFamily: 'Manrope',
              ),
            ),
            TextButton(
              onPressed: onCalendarTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text(
                    'Calendar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4F46E5),
                      fontFamily: 'Manrope',
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Color(0xFF4F46E5),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // --- Horizontal Cards Layout (Safe & Responsive) ---
        if (meetings.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: Text(
                'No upcoming meetings',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  fontFamily: 'Manrope',
                ),
              ),
            ),
          )
        else
          Wrap(
            spacing: 12, // Cards ke beech horizontal gap
            runSpacing: 12, // Lines ke beech vertical gap
            children: meetings.asMap().entries.map((entry) {
              final index = entry.key;
              final meeting = entry.value;
              // Bilkul screenshot jaisa 2-column grid banana
              final widthFactor = meetings.length == 1
                  ? 1.0
                  : 0.48; // Agar 1 hai toh full width, 2+ hain toh 48%
              return SizedBox(
                width: MediaQuery.of(context).size.width * widthFactor - 20,
                child: _MeetingCard(meeting: meeting),
              );
            }).toList(),
          ),
      ],
    );
  }
}

// --- Individual Meeting Card ---
class _MeetingCard extends StatelessWidget {
  final MeetingModel meeting;

  const _MeetingCard({required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Left Dot
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF6366F1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            meeting.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 8),
          // Time
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 14,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                meeting.time,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // People
          Row(
            children: [
              const Icon(
                Icons.people_outline_rounded,
                size: 14,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                '${meeting.peopleCount} people',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
