import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/feed_provider.dart';
import '../../widgets/feed/post_card.dart';
import '../../widgets/feed/story_bubble.dart';

import '../feed/create_content_screen.dart';
import '../messages/messages_list_screen.dart';
import '../notifications/notifications_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await loadFeed();
    });
  }

  Future<void> loadFeed() async {
    final provider = context.read<FeedProvider>();

    await provider.fetchStories();
    await provider.fetchFeed();
  }

  Future<void> openCreateStory() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateContentScreen(initialTab: 1),
      ),
    );

    if (created == true) {
      await loadFeed();
    }
  }

  Future<void> openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  Future<void> openMessages() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MessagesListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadFeed,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    elevation: 0,
                    backgroundColor: backgroundColor,
                    title: Text(
                      'Velora',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: openNotifications,
                        icon: Icon(Icons.favorite_border, color: textColor),
                      ),
                      IconButton(
                        onPressed: openMessages,
                        icon: Icon(Icons.send_outlined, color: textColor),
                      ),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 118,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingM,
                        ),
                        children: [
                          _AddStoryBubble(onTap: openCreateStory),
                          ...provider.stories.map(
                            (story) => StoryBubble(story: story),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (provider.posts.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('Aún no hay publicaciones')),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final post = provider.posts[index];

                        return PostCard(post: post);
                      }, childCount: provider.posts.length),
                    ),
                ],
              ),
            ),
    );
  }
}

class _AddStoryBubble extends StatelessWidget {
  final VoidCallback onTap;

  const _AddStoryBubble({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 82,
        margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.maroonOak, AppColors.accent],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: cardColor,
                    child: Icon(Icons.person, color: textColor, size: 34),
                  ),
                ),
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.backgroundDark
                            : AppColors.backgroundLight,
                        width: 2,
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Tu historia',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
