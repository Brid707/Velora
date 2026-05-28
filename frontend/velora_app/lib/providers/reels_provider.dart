import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../data/models/reel_model.dart';

class ReelsProvider extends ChangeNotifier {
  bool loading = false;

  List<ReelModel> reels = [];

  Future<void> fetchReels() async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.get('reels');

      final List<dynamic> data = response['data'] ?? [];

      reels = data.map((json) => ReelModel.fromJson(json)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> likeReel(String reelId) async {
    final index = reels.indexWhere((reel) => reel.id == reelId);

    if (index == -1) return;

    final current = reels[index];

    reels[index] = current.copyWith(
      likedByMe: !current.likedByMe,
      likesCount: current.likedByMe
          ? current.likesCount - 1
          : current.likesCount + 1,
    );

    notifyListeners();

    try {
      await ApiService.post('reels/$reelId/like', {});
    } catch (_) {}
  }
}
