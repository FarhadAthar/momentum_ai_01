import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        8,
      ), // 👈 YAHAN 24 se 8 kar diya
      height: 76,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.9),
              blurRadius: 18,
              offset: const Offset(-8, -8),
            ),
            BoxShadow(
              color: const Color(0xFFB0B8C4).withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(8, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'Home',
              selectedIndex: selectedIndex,
              onTap: onItemTapped,
            ),
            _NavItem(
              index: 1,
              icon: Icons.checklist_rounded,
              label: 'Tasks',
              selectedIndex: selectedIndex,
              onTap: onItemTapped,
            ),
            _NavItem(
              index: 2,
              icon: Icons.bolt_rounded,
              label: 'Focus',
              selectedIndex: selectedIndex,
              onTap: onItemTapped,
            ),
            _NavItem(
              index: 3,
              icon: Icons.analytics_rounded,
              label: 'Stats',
              selectedIndex: selectedIndex,
              onTap: onItemTapped,
            ),
            _NavItem(
              index: 4,
              icon: Icons.chat_bubble_outline_rounded,
              label: 'AI',
              selectedIndex: selectedIndex,
              onTap: onItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final int selectedIndex;
  final Function(int) onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(32),
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 44,
              width: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutQuart,
                    width: isSelected ? 44 : 0,
                    height: isSelected ? 44 : 0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF6366F1,
                                ).withValues(alpha: 0.30),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.6),
                                blurRadius: 6,
                                offset: const Offset(-3, -3),
                              ),
                            ]
                          : [],
                    ),
                  ),
                  AnimatedScale(
                    scale: isSelected ? 1.1 : 0.85,
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutQuart,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isSelected ? 1.0 : 0.6,
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6B7280),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              textAlign: TextAlign.center,
              style: isSelected
                  ? GoogleFonts.manrope(
                      color: const Color(0xFF6366F1),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                      shadows: [
                        Shadow(
                          color: const Color(
                            0xFF6366F1,
                          ).withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: Offset.zero,
                        ),
                      ],
                    )
                  : GoogleFonts.manrope(
                      color: const Color(0xFF6B7280),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
