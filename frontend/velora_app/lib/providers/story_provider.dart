import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../data/models/story_model.dart';

class StoryProvider extends ChangeNotifier {
  bool loading = false;

  List<StoryModel> stories = [];

  Future<void> fetchStories() async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.get('stories/feed');

      final List<dynamic> data = response['data'] ?? [];

      stories = data.map((e) => StoryModel.fromJson(e)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> createStory({
    required String mediaUrl,
    required String userId,
  }) async {
    await ApiService.post('stories', {
      'userId': userId,
      'mediaUrl': mediaUrl,
      'mediaType': 'image',
    });

    await fetchStories();
  }
}
