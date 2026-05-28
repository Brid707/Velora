import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/notification_model.dart';
import '../../providers/notifications_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<NotificationsProvider>().fetchNotifications();
    });
  }

  IconData notificationIcon(String type) {
    switch (type.toUpperCase()) {
      case 'LIKE':
        return Icons.favorite;
      case 'COMMENT':
        return Icons.mode_comment_outlined;
      case 'FOLLOW':
        return Icons.person_add_alt_1;
      case 'REPOST':
        return Icons.repeat;
      case 'MESSAGE':
        return Icons.send_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color notificationColor(String type) {
    switch (type.toUpperCase()) {
      case 'LIKE':
        return Colors.red;
      case 'COMMENT':
        return AppColors.accent;
      case 'FOLLOW':
        return Colors.blue;
      case 'REPOST':
        return AppColors.maroonOak;
      case 'MESSAGE':
        return Colors.green;
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.notifications.isEmpty
          ? const Center(child: Text('Aún no tienes notificaciones'))
          : RefreshIndicator(
              onRefresh: provider.fetchNotifications,
              child: ListView.separated(
                itemCount: provider.notifications.length,
                separatorBuilder: (_, __) => Divider(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                itemBuilder: (context, index) {
                  final notification = provider.notifications[index];

                  return _NotificationTile(
                    notification: notification,
                    icon: notificationIcon(notification.type),
                    color: notificationColor(notification.type),
                  );
                },
              ),
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final IconData icon;
  final Color color;

  const _NotificationTile({
    required this.notification,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.accent,
            backgroundImage: notification.senderProfileImage.isNotEmpty
                ? NetworkImage(notification.senderProfileImage)
                : null,
            child: notification.senderProfileImage.isEmpty
                ? Text(
                    notification.senderUsername.isNotEmpty
                        ? notification.senderUsername[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: color,
              child: Icon(icon, size: 13, color: Colors.white),
            ),
          ),
        ],
      ),
      title: Text(
        notification.message,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        notification.createdAt,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: notification.postId != null
          ? const Icon(Icons.chevron_right)
          : null,
    );
  }
}
