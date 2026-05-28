import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../data/models/post_model.dart';
import '../data/models/story_model.dart';

class FeedProvider extends ChangeNotifier {
  bool loading = false;

  List<PostModel> posts = [];
  List<StoryModel> stories = [];

  Future<void> fetchFeed() async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.get('posts/feed');
      final List<dynamic> data = response['data'] ?? [];

      posts = data.map((json) => PostModel.fromJson(json)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStories() async {
    final response = await ApiService.get('stories/feed');
    final List<dynamic> data = response['data'] ?? [];

    stories = data.map((json) => StoryModel.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> likePost(String postId) async {
    await ApiService.post('likes/$postId', {});
    await fetchFeed();
  }

  Future<void> savePost(String postId) async {
    await ApiService.post('saved/$postId', {});
    await fetchFeed();
  }

  Future<void> repostPost(String postId, {String comment = ''}) async {
    await ApiService.post('reposts/$postId', {'comment': comment});

    await fetchFeed();
  }
}
