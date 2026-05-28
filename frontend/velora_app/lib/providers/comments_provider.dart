import 'package:flutter/material.dart';

import '../core/services/api_service.dart';

import '../data/models/comment_model.dart';

class CommentsProvider extends ChangeNotifier {
  bool loading = false;

  List<CommentModel> comments = [];

  Future<void> fetchComments(String postId) async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.get('comments/$postId');

      final List<dynamic> data = response['data'] ?? [];

      comments = data.map((json) => CommentModel.fromJson(json)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> createComment({
    required String postId,
    required String content,
  }) async {
    await ApiService.post('comments/$postId', {'content': content});

    await fetchComments(postId);
  }
}
