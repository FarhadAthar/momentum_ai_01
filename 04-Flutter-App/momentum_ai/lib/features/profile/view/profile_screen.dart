import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momentum_ai/app/router.dart';

import '../view_model/profile_view_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final xpProgress = state.currentXp / state.maxXp;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: 20,
            color: Color(0xFF111827),
          ),
          onPressed: () => context.pop(),
        ),
        centerTitle: false,
        title: Text(
          'Profile',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
        children: [
          // --- Purple Header Card ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const FaIcon(
                        FontAwesomeIcons.user,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.name,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            state.role,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.crown,
                                size: 14,
                                color: const Color(0xFFFBBF24),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Level ${state.level} · Pro',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFFBBF24),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.gear,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // XP Progress Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'XP Progress - Level ${state.level}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '${state.currentXp} / ${state.maxXp} XP',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: xpProgress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFF97316),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${state.maxXp - state.currentXp} XP to Level ${state.level + 1}',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- Stats Grid ---
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
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
              children: [
                _StatItem(
                  icon: FontAwesomeIcons.squareCheck,
                  iconColor: const Color(0xFF10B981),
                  value: '${state.tasksDone}',
                  label: 'Tasks Done',
                ),
                _StatItem(
                  icon: FontAwesomeIcons.stopwatch,
                  iconColor: const Color(0xFF6366F1),
                  value: state.focusHours,
                  label: 'Focus Hours',
                ),
                _StatItem(
                  icon: FontAwesomeIcons.percent,
                  iconColor: const Color(0xFFEF4444),
                  value: state.habits,
                  label: 'Habits',
                ),
                _StatItem(
                  icon: FontAwesomeIcons.fire,
                  iconColor: const Color(0xFFF97316),
                  value: '${state.streak}',
                  label: 'Streak',
                ),
                _StatItem(
                  icon: FontAwesomeIcons.trophy,
                  iconColor: const Color(0xFFFBBF24),
                  value: '${state.goals}',
                  label: 'Goals',
                ),
                _StatItem(
                  icon: FontAwesomeIcons.noteSticky,
                  iconColor: const Color(0xFF4F46E5),
                  value: '${state.notes}',
                  label: 'Notes',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- Upgrade to Pro Banner ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF97316), Color(0xFFEA580C)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF97316).withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.star,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upgrade to Pro',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Unlimited AI · Analytics · Coaching',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: InkWell(
                    // 👈 Wrap with InkWell
                    onTap: () => context.push(AppRoutes.subscription),
                    child: Text(
                      'View Plans',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- Achievements Section (FIXED) ---
          Text(
            'Achievements',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio:
                0.75, // 👈 0.9 se 0.75 kar diya hai taake height barh jaye
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: const [
              _AchievementCard(
                icon: '🔥',
                title: 'On Fire',
                subtitle: '12-day streak',
                isUnlocked: true,
              ),
              _AchievementCard(
                icon: '⚡',
                title: 'Speed Demon',
                subtitle: '10 tasks in 1 day',
                isUnlocked: true,
              ),
              _AchievementCard(
                icon: '🎯',
                title: 'Laser Focus',
                subtitle: '5h focus session',
                isUnlocked: true,
              ),
              _AchievementCard(
                icon: '🏆',
                title: 'Goal Crusher',
                subtitle: '3 goals completed',
                isUnlocked: false,
              ),
              _AchievementCard(
                icon: '📚',
                title: 'Knowledge Pro',
                subtitle: '50 notes created',
                isUnlocked: false,
              ),
              _AchievementCard(
                icon: '👑',
                title: 'Productivity King',
                subtitle: 'Level 20',
                isUnlocked: false,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --- Menu List ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
              children: [
                _MenuTile(
                  icon: FontAwesomeIcons.bell,
                  title: 'Notifications',
                  subtitle: 'Morning briefing · Reminders',
                ),
                _MenuTile(
                  icon: FontAwesomeIcons.shield,
                  title: 'Privacy & Security',
                  subtitle: 'Data, permissions',
                ),
                _MenuTile(
                  icon: FontAwesomeIcons.download,
                  title: 'Export Reports',
                  subtitle: 'PDF, CSV, JSON',
                ),
                _MenuTile(
                  icon: FontAwesomeIcons.shareNodes,
                  title: 'Invite Friends',
                  subtitle: 'Get 1 month Pro free',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// --- Helper Widgets ---

class _StatItem extends StatelessWidget {
  final FaIconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(icon, color: iconColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111827),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isUnlocked;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10), // Padding thoda kam kiya
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: isUnlocked
            ? null
            : Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1, // 👈 Text ko ek line tak limit kar diya
            overflow: TextOverflow
                .ellipsis, // 👈 Text overflow hone par dots laga diye
            style: GoogleFonts.manrope(
              fontSize: 11, // Font size thoda sa kam kiya
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Icon(
            isUnlocked
                ? Icons.check_circle_rounded
                : Icons.lock_outline_rounded,
            color: isUnlocked
                ? const Color(0xFF10B981)
                : const Color(0xFFD1D5DB),
            size: 14,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final FaIconData icon;
  final String title;
  final String subtitle;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FaIcon(icon, color: const Color(0xFF6B7280), size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF111827),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF9CA3AF),
        ),
      ),
      trailing: const FaIcon(
        FontAwesomeIcons.chevronRight,
        color: Color(0xFF9CA3AF),
        size: 16,
      ),
      onTap: () {},
    );
  }
}
