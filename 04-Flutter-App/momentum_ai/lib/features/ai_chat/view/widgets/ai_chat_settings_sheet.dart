import 'package:flutter/material.dart';

// Helper function to show the sheet
void showAiChatSettingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AiChatSettingsSheet(),
  );
}

class AiChatSettingsSheet extends StatefulWidget {
  const AiChatSettingsSheet({super.key});

  @override
  State<AiChatSettingsSheet> createState() => _AiChatSettingsSheetState();
}

class _AiChatSettingsSheetState extends State<AiChatSettingsSheet> {
  // Local settings mock state
  String _selectedModel = 'GPT-4o';
  String _selectedPersona = 'Productivity Coach';
  bool _autoScroll = true;
  bool _enableVoiceInput = true;
  bool _showTimestamps = false;

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
                'AI Assistant Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontFamily: 'SpaceGrotesk',
                ),
              ),
              const SizedBox(height: 24),

              // 1. AI Model Selection
              _buildSectionTitle('AI Model', isDark),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['GPT-4o', 'GPT-3.5', 'Claude 3'].map((model) {
                  final isSelected = _selectedModel == model;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedModel = model),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
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
                        model,
                        style: TextStyle(
                          fontSize: 13,
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

              const SizedBox(height: 20),

              // 2. Persona Selection
              _buildSectionTitle('AI Persona', isDark),
              const SizedBox(height: 12),
              // 👇 FIX: Horizontal Scrollable Row taake overflow na ho aur wrap na ho
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Productivity Coach', 'Motivational', 'Concise']
                      .map((persona) {
                        final isSelected = _selectedPersona == persona;
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ), // Cards ke beech gap
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedPersona = persona),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF8B5CF6)
                                    : isDark
                                    ? const Color(0xFF2A2A2A)
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF8B5CF6,
                                          ).withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Text(
                                persona,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),

              // 3. Auto-scroll to new messages
              _buildSwitchRow(
                title: 'Auto-scroll to new messages',
                subtitle: 'Automatically scroll down when AI replies',
                value: _autoScroll,
                onChanged: (val) => setState(() => _autoScroll = val),
                isDark: isDark,
              ),

              // 4. Enable Voice Input
              _buildSwitchRow(
                title: 'Enable Voice Input',
                subtitle: 'Use microphone to dictate messages',
                value: _enableVoiceInput,
                onChanged: (val) => setState(() => _enableVoiceInput = val),
                isDark: isDark,
              ),

              // 5. Show Timestamps
              _buildSwitchRow(
                title: 'Show Message Timestamps',
                subtitle: 'Display timestamps next to messages',
                value: _showTimestamps,
                onChanged: (val) => setState(() => _showTimestamps = val),
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
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(
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
