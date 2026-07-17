import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final navigationBarColor = isDark
        ? const Color(0xFF111827)
        : const Color(0xFFF3F4F6);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            // 👇 FIX: Back icon auto dark/light color
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Settings',
            // 👇 FIX: Main Heading auto dark/light color
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            children: [
              // Account Section
              _SettingsGroup(
                title: 'Account',
                children: [
                  _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    subtitle: 'Name, photo, and bio',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notification Preferences',
                    subtitle: 'Alerts, reminders, and sounds',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Preferences Section
              _SettingsGroup(
                title: 'Preferences',
                children: [
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Appearance',
                    subtitle: 'Dark mode, light mode',
                    trailing: Text(
                      _getThemeLabel(currentTheme),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontFamily: 'Manrope',
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) {
                          return const _AppearanceBottomSheet();
                        },
                      );
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'English (United States)',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Support Section
              _SettingsGroup(
                title: 'Support',
                children: [
                  _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    subtitle: 'FAQs and guides',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Terms & Privacy',
                    subtitle: 'Privacy policy and terms of use',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.star_outline_rounded,
                    title: 'Rate Momentum AI',
                    subtitle: 'Your feedback helps us grow!',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Account Action
              _SettingsGroup(
                title: '',
                children: [
                  _SettingsTile(
                    icon: Icons.logout_rounded,
                    iconColor: const Color.fromARGB(255, 240, 68, 68),
                    title: 'Log Out',
                    titleColor: const Color(0xFFEF4444),
                    subtitle: 'Sign out of your account',
                    subtitleColor: const Color(
                      0xFFEF4444,
                    ).withValues(alpha: 0.6),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}

// --- Reusable Group Widget ---
class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
            child: Text(
              title,
              // 👇 FIX: Sub-headings dynamic color (Dark mein soft white, Light mein grey)
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
                fontFamily: 'Manrope',
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
        Container(
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
          child: Column(children: children),
        ),
      ],
    );
  }
}

// --- Reusable Tile Widget ---
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String subtitle;
  final Color subtitleColor;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    this.iconColor = const Color.fromARGB(255, 107, 114, 128),
    required this.title,
    this.titleColor = const Color.fromARGB(255, 17, 24, 39),
    required this.subtitle,
    this.subtitleColor = const Color.fromARGB(255, 156, 163, 175),
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👇 FIX: Title auto dark/light color
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontFamily: 'Manrope',
                    ),
                  ),
                  const SizedBox(height: 2),
                  // 👇 FIX: Subtitle auto dark/light color
                  Text(
                    subtitle,
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
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFFD1D5DB),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Appearance Bottom Sheet ---
class _AppearanceBottomSheet extends ConsumerWidget {
  const _AppearanceBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Appearance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 20),
          _buildThemeOption(
            context,
            'Light',
            ThemeMode.light,
            currentTheme,
            ref,
          ),
          _buildThemeOption(context, 'Dark', ThemeMode.dark, currentTheme, ref),
          _buildThemeOption(
            context,
            'System',
            ThemeMode.system,
            currentTheme,
            ref,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label,
    ThemeMode mode,
    ThemeMode currentMode,
    WidgetRef ref,
  ) {
    final isSelected = currentMode == mode;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ref.read(themeProvider.notifier).setThemeMode(mode);
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEDE9FE) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : (isDark ? Colors.white : const Color(0xFF111827)),
                  fontFamily: 'Manrope',
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF6366F1),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
