import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/story_model.dart';
import '../../views/stories/story_view_screen.dart';

class StoryBubble extends StatelessWidget {
  final StoryModel story;

  const StoryBubble({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StoryViewScreen(story: story)),
        );
      },
      child: Container(
        width: 82,
        margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.accent, AppColors.maroonOak],
                ),
              ),
              child: CircleAvatar(
                radius: 31,
                backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(story.user.profileImageUrl),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.user.username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
