import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../view_model/profile_view_model.dart';
import '../../../app/router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: Color(0xFF121212),
              systemNavigationBarIconBrightness: Brightness.light,
            )
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
              systemNavigationBarColor: Color(0xFFF3F4F6),
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          systemOverlayStyle: isDark
              ? const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                )
              : const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              size: 20,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
            onPressed: () => context.pop(),
          ),
          centerTitle: false,
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontFamily: 'SpaceGrotesk',
            ),
          ),
        ),
        // 👇 PRODUCTION-GRADE ASYNC HANDLING
        body: profileAsync.when(
          data: (profile) {
            final xpProgress = profile.currentXp / profile.maxXp;

            return ListView(
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
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
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
                                  profile.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontFamily: 'SpaceGrotesk',
                                  ),
                                ),
                                Text(
                                  profile.role,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Manrope',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.crown,
                                      size: 14,
                                      color: Color(0xFFFBBF24),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Level ${profile.level} · Pro',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFFBBF24),
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.settings),
                            child: Container(
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'XP Progress - Level ${profile.level}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Manrope',
                            ),
                          ),
                          Text(
                            '${profile.currentXp} / ${profile.maxXp} XP',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontFamily: 'Manrope',
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
                        '${profile.maxXp - profile.currentXp} XP to Level ${profile.level + 1}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Manrope',
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
                        value: '${profile.tasksDone}',
                        label: 'Tasks Done',
                        isDark: isDark,
                      ),
                      _StatItem(
                        icon: FontAwesomeIcons.stopwatch,
                        iconColor: const Color(0xFF6366F1),
                        value: profile.focusHours,
                        label: 'Focus Hours',
                        isDark: isDark,
                      ),
                      _StatItem(
                        icon: FontAwesomeIcons.percent,
                        iconColor: const Color(0xFFEF4444),
                        value: profile.habits,
                        label: 'Habits',
                        isDark: isDark,
                      ),
                      _StatItem(
                        icon: FontAwesomeIcons.fire,
                        iconColor: const Color(0xFFF97316),
                        value: '${profile.streak}',
                        label: 'Streak',
                        isDark: isDark,
                      ),
                      _StatItem(
                        icon: FontAwesomeIcons.trophy,
                        iconColor: const Color(0xFFFBBF24),
                        value: '${profile.goals}',
                        label: 'Goals',
                        isDark: isDark,
                      ),
                      _StatItem(
                        icon: FontAwesomeIcons.noteSticky,
                        iconColor: const Color(0xFF4F46E5),
                        value: '${profile.notes}',
                        label: 'Notes',
                        isDark: isDark,
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontFamily: 'Manrope',
                              ),
                            ),
                            Text(
                              'Unlimited AI · Analytics · Coaching',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Manrope',
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.subscription),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            'View Plans',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Achievements Section ---
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.75,
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

                const SizedBox(height: 28),

                // --- Premium Menu List ---
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
                    children: [
                      _MenuTile(
                        icon: FontAwesomeIcons.bell,
                        title: 'Notifications',
                        subtitle: 'Morning briefing · Reminders',
                        onTap: () => context.push(AppRoutes.notifications),
                        isDark: isDark,
                      ),
                      _MenuTile(
                        icon: FontAwesomeIcons.shield,
                        title: 'Privacy & Security',
                        subtitle: 'Data, permissions',
                        onTap: () {},
                        isDark: isDark,
                      ),
                      _MenuTile(
                        icon: FontAwesomeIcons.download,
                        title: 'Export Reports',
                        subtitle: 'PDF, CSV, JSON',
                        onTap: () {},
                        isDark: isDark,
                      ),
                      _MenuTile(
                        icon: FontAwesomeIcons.shareNodes,
                        title: 'Invite Friends',
                        subtitle: 'Get 1 month Pro free',
                        onTap: () {},
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFEF4444),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontFamily: 'Manrope',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontFamily: 'Manrope',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- Helper Widgets (Same as before, unchanged) ---

class _StatItem extends StatelessWidget {
  final FaIconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool isDark;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(icon, color: iconColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontFamily: 'Manrope',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontFamily: 'Manrope',
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUnlocked
            ? Theme.of(context).cardColor
            : Theme.of(context).cardColor.withValues(alpha: 0.6),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontFamily: 'Manrope',
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              fontFamily: 'Manrope',
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
  final VoidCallback? onTap;
  final bool isDark;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      onTap: onTap ?? () {},
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FaIcon(icon, color: const Color(0xFF6B7280), size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : const Color(0xFF111827),
          fontFamily: 'Manrope',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontFamily: 'Manrope',
        ),
      ),
      trailing: const FaIcon(
        FontAwesomeIcons.chevronRight,
        color: Color(0xFF9CA3AF),
        size: 16,
      ),
    );
  }
}
