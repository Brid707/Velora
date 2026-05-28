import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../data/models/post_model.dart';

class SavedProvider extends ChangeNotifier {
  bool loading = false;
  List<PostModel> savedPosts = [];

  Future<void> fetchSavedPosts() async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.get('saved');
      final List<dynamic> data = response['data'] ?? [];

      savedPosts = data.map((json) => PostModel.fromJson(json)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
