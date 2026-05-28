import 'package:flutter/material.dart';

import '../core/services/api_service.dart';

import '../data/models/post_model.dart';
import '../data/models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  bool loading = false;

  UserModel? user;

  List<PostModel> posts = [];

  Future<void> fetchMyProfile() async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.get('users/me');

      user = UserModel.fromJson(response['data']['user']);

      final List<dynamic> postsJson = response['data']['posts'] ?? [];

      posts = postsJson.map((json) => PostModel.fromJson(json)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
