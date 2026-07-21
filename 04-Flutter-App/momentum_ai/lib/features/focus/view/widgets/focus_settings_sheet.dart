import 'package:flutter/material.dart';

// Helper function to show the sheet
void showFocusSettingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FocusSettingsSheet(),
  );
}

class FocusSettingsSheet extends StatefulWidget {
  const FocusSettingsSheet({super.key});

  @override
  State<FocusSettingsSheet> createState() => _FocusSettingsSheetState();
}

class _FocusSettingsSheetState extends State<FocusSettingsSheet> {
  // Local state for settings (in future, these will be connected to ViewModel)
  int _pomodoroDuration = 25; // in minutes
  bool _autoStartTimer = true;
  bool _muteNotifications = false;
  bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Text(
                'Focus Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontFamily: 'SpaceGrotesk',
                ),
              ),
              const SizedBox(height: 24),

              // 1. Pomodoro Duration
              _buildSectionTitle('Pomodoro Length', isDark),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [25, 30, 45].map((duration) {
                  final isSelected = _pomodoroDuration == duration;
                  return GestureDetector(
                    onTap: () => setState(() => _pomodoroDuration = duration),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6366F1)
                            : isDark
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        '${duration}m',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // 2. Auto-start Timer
              _buildSwitchRow(
                title: 'Auto-start Timer',
                subtitle: 'Timer starts automatically at the end of break',
                value: _autoStartTimer,
                onChanged: (val) => setState(() => _autoStartTimer = val),
                isDark: isDark,
              ),

              // 3. Mute Notifications
              _buildSwitchRow(
                title: 'Mute Notifications',
                subtitle: 'Block incoming notifications during focus',
                value: _muteNotifications,
                onChanged: (val) => setState(() => _muteNotifications = val),
                isDark: isDark,
              ),

              // 4. Vibration
              _buildSwitchRow(
                title: 'Vibration',
                subtitle: 'Haptic feedback when timer completes',
                value: _vibration,
                onChanged: (val) => setState(() => _vibration = val),
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              // Done Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Save Settings',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontFamily: 'Manrope',
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          const SizedBox(width: 12),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6366F1),
            activeTrackColor: const Color(0xFF6366F1).withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}
