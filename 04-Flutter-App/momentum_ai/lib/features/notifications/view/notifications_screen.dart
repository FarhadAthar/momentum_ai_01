// lib/features/notifications/view/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_model/notification_view_model.dart';
import '../model/notification_model.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationViewModelProvider);
    final notifier = ref.read(notificationViewModelProvider.notifier);

    final unreadCount = state.notifications.where((n) => n.isUnread).length;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF3F4F6),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: Color(0xFF111827),
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Notifications',
            // 👇 GoogleFonts hata kar TextStyle + FontFamily use kiya
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // --- Header Counts ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$unreadCount unread',
                      // 👇 GoogleFonts hata kar TextStyle + FontFamily use kiya
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Manrope',
                      ),
                    ),
                    if (unreadCount > 0)
                      TextButton(
                        onPressed: notifier.markAllRead,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Mark all read',
                          // 👇 GoogleFonts hata kar TextStyle + FontFamily use kiya
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF4F46E5),
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Notification List ---
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  itemCount: state.notifications.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.notifications[index];
                    return _NotificationCard(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Custom Premium Card Widget ---
class _NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Left Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: const Color(0xFF4B5563), size: 20),
          ),
          const SizedBox(width: 14),

          // 2. Middle Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  // 👇 GoogleFonts hata kar TextStyle + FontFamily use kiya
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  // 👇 GoogleFonts hata kar TextStyle + FontFamily use kiya
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.time,
                  // 👇 GoogleFonts hata kar TextStyle + FontFamily use kiya
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF9CA3AF),
                    fontFamily: 'Manrope',
                  ),
                ),
              ],
            ),
          ),

          // 3. Right Unread Dot
          SizedBox(
            width: 24,
            child: Align(
              alignment: Alignment.topCenter,
              child: item.isUnread
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
