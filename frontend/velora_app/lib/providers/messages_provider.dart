import 'package:flutter/material.dart';

import '../core/services/api_service.dart';

import '../data/models/message_model.dart';

class MessagesProvider extends ChangeNotifier {
  bool loading = false;

  List<MessageModel> messages = [];

  Future<void> fetchMessages(String userId) async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.get('messages/$userId');

      final List<dynamic> data = response['data'] ?? [];

      messages = data.map((json) => MessageModel.fromJson(json)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    await ApiService.post('messages', {
      'receiverId': receiverId,
      'content': content,
    });

    await fetchMessages(receiverId);
  }
}
