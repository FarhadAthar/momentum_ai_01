import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// 👇 YE IMPORT LINE SAB SE ZAROORI HAI
import '../view_model/focus_view_model.dart';

class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(focusViewModelProvider);
    final notifier = ref.read(focusViewModelProvider.notifier);

    final duration = Duration(seconds: state.remainingSeconds);
    final formattedTime = DateFormat('mm:ss').format(DateTime(0).add(duration));

    final totalSessions = state.totalSessions;
    final completedSessions = state.completedSessions;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session ${state.currentSession} of $totalSessions • Pomodoro',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Focus Mode',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFF6B7280),
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Current Task Dropdown Card ---
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEDE9FE), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Currently focusing on',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            state.currentTask,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Premium Circular Timer ---
              Center(
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(220, 220),
                        painter: TimerPainter(progress: state.progress),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formattedTime,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF111827),
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'remaining',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${(state.progress * 100).toStringAsFixed(0)}% complete',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- Controls Row ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NeumorphicButton(
                    icon: Icons.skip_previous_rounded,
                    onTap: notifier.skipToPrevious,
                  ),
                  const SizedBox(width: 20),
                  // Play/Pause Premium Button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      notifier.toggleTimer();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutQuart,
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            state.isRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            key: ValueKey(state.isRunning),
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _NeumorphicButton(
                    icon: Icons.close_rounded,
                    onTap: () {
                      // Reset timer logic could be here
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- Progress Dots ---
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalSessions, (index) {
                    final bool isCompleted = index < completedSessions;
                    final bool isCurrent = index == completedSessions;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isCompleted ? 28 : (isCurrent ? 28 : 12),
                      height: 6,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFF8B5CF6)
                            : (isCurrent
                                  ? const Color(0xFF8B5CF6)
                                  : const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF8B5CF6,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 30),

              // --- Background Sounds Card ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    Row(
                      children: [
                        const Icon(
                          Icons.music_note_rounded,
                          size: 18,
                          color: Color(0xFF6D28D9),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Background Sounds',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.volume_up_rounded,
                          size: 18,
                          color: Color(0xFF9CA3AF),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Ocean 🌊', 'Café ☕', 'Rain 🌧️', 'Forest 🌲']
                          .map((sound) {
                            final bool isSelected =
                                state.selectedSound == sound.split(' ')[0];
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                notifier.selectSound(sound.split(' ')[0]);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : const Color(0xFFE5E7EB),
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF6366F1,
                                            ).withValues(alpha: 0.25),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  sound,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- Focus Queue Card ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                      'Focus Queue',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...state.focusQueue.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final String task = entry.value;
                      final bool isCompleted = index < completedSessions;
                      final bool isCurrent = state.currentTask == task;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? const Color(0xFF10B981)
                                    : (isCurrent
                                          ? const Color(0xFF6366F1)
                                          : Colors.transparent),
                                border: Border.all(
                                  color: isCompleted
                                      ? const Color(0xFF10B981)
                                      : (isCurrent
                                            ? const Color(0xFF6366F1)
                                            : const Color(0xFFD1D5DB)),
                                  width: 2,
                                ),
                              ),
                              child: isCompleted
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                task,
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: isCurrent
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isCompleted
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF111827),
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- Stats Cards ---
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.timer_rounded,
                      iconColor: const Color(0xFFEF4444),
                      value: '$completedSessions',
                      label: 'Sessions',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.hourglass_empty_rounded,
                      iconColor: const Color(0xFF6366F1),
                      value: '52m',
                      label: 'Focus Time',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.fitness_center_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      value: '1.8h',
                      label: 'Deep Work',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Helper Sub-Widgets ---

class _NeumorphicButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NeumorphicButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 6,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF4B5563), size: 22),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Custom Painter for Circular Timer (Fix applied) ---
class TimerPainter extends CustomPainter {
  final double progress;
  TimerPainter({required this.progress}); // 👈 Fix applied here

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;

    final backgroundPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
