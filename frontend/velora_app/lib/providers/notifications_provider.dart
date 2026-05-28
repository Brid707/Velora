import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../data/models/notification_model.dart';

class NotificationsProvider extends ChangeNotifier {
  bool loading = false;

  List<NotificationModel> notifications = [];

  Future<void> fetchNotifications() async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.get('notifications');
      final List<dynamic> data = response['data'] ?? [];

      notifications = data
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
