// lib/features/notifications/model/notification_model.dart
import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconBgColor;
  final bool isUnread;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconBgColor,
    this.isUnread = true,
  });

  NotificationItem copyWith({bool? isUnread}) {
    return NotificationItem(
      id: id,
      title: title,
      description: description,
      time: time,
      icon: icon,
      iconBgColor: iconBgColor,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}
