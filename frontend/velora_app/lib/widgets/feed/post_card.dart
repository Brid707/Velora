import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/post_model.dart';
import '../../providers/feed_provider.dart';
import '../../views/feed/comments_screen.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool liked;
  late bool saved;
  late bool reposted;

  late int likesCount;
  late int savedCount;
  late int repostsCount;
  late int commentsCount;

  @override
  void initState() {
    super.initState();

    liked = widget.post.likedByMe;
    saved = widget.post.savedByMe;
    reposted = widget.post.repostedByMe;

    likesCount = widget.post.likesCount;
    savedCount = widget.post.savedCount;
    repostsCount = widget.post.repostsCount;
    commentsCount = widget.post.commentsCount;
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.post.id != widget.post.id ||
        oldWidget.post.likesCount != widget.post.likesCount ||
        oldWidget.post.savedCount != widget.post.savedCount ||
        oldWidget.post.repostsCount != widget.post.repostsCount ||
        oldWidget.post.commentsCount != widget.post.commentsCount) {
      liked = widget.post.likedByMe;
      saved = widget.post.savedByMe;
      reposted = widget.post.repostedByMe;

      likesCount = widget.post.likesCount;
      savedCount = widget.post.savedCount;
      repostsCount = widget.post.repostsCount;
      commentsCount = widget.post.commentsCount;
    }
  }

  Future<void> toggleLike() async {
    final oldLiked = liked;
    final oldCount = likesCount;

    setState(() {
      liked = !liked;
      likesCount += liked ? 1 : -1;
      if (likesCount < 0) likesCount = 0;
    });

    try {
      await context.read<FeedProvider>().likePost(widget.post.id);
    } catch (_) {
      setState(() {
        liked = oldLiked;
        likesCount = oldCount;
      });
    }
  }

  Future<void> toggleSave() async {
    final oldSaved = saved;
    final oldCount = savedCount;

    setState(() {
      saved = !saved;
      savedCount += saved ? 1 : -1;
      if (savedCount < 0) savedCount = 0;
    });

    try {
      await context.read<FeedProvider>().savePost(widget.post.id);
    } catch (_) {
      setState(() {
        saved = oldSaved;
        savedCount = oldCount;
      });
    }
  }

  Future<void> toggleRepost() async {
    final oldReposted = reposted;
    final oldCount = repostsCount;

    setState(() {
      reposted = !reposted;
      repostsCount += reposted ? 1 : -1;
      if (repostsCount < 0) repostsCount = 0;
    });

    try {
      await context.read<FeedProvider>().repostPost(widget.post.id);
    } catch (_) {
      setState(() {
        reposted = oldReposted;
        repostsCount = oldCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.repost == true && post.repostedBy != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.repeat, size: 16, color: AppColors.accent),
                const SizedBox(width: 6),
                Text(
                  '${post.repostedBy!.username} reposteó',
                  style: TextStyle(
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: post.user.profileImageUrl.isNotEmpty
                    ? NetworkImage(post.user.profileImageUrl)
                    : null,
                child: post.user.profileImageUrl.isEmpty
                    ? Text(
                        post.user.username.isNotEmpty
                            ? post.user.username[0].toUpperCase()
                            : '?',
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.username,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                    ),
                    Text(
                      post.user.fullName,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
        ),

        GestureDetector(
          onDoubleTap: toggleLike,
          child: CachedNetworkImage(
            imageUrl: post.mediaUrl,
            width: double.infinity,
            height: 420,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 420,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              height: 420,
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              child: const Center(
                child: Icon(Icons.broken_image_outlined, size: 48),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: toggleLike,
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Colors.red : null,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommentsScreen(postId: post.id),
                    ),
                  );

                  if (mounted) {
                    await context.read<FeedProvider>().fetchFeed();
                  }
                },
                icon: const Icon(Icons.mode_comment_outlined),
              ),
              IconButton(
                onPressed: toggleRepost,
                icon: Icon(
                  Icons.repeat,
                  color: reposted ? AppColors.accent : null,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: toggleSave,
                icon: Icon(
                  saved ? Icons.bookmark : Icons.bookmark_border,
                  color: saved ? AppColors.accent : null,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$likesCount likes',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
        ),

        if (commentsCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Ver $commentsCount comentarios',
              style: TextStyle(
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
            ),
          ),

        if (repostsCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '$repostsCount reposts',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ),

        if (savedCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '$savedCount guardados',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
            ),
          ),

        if (post.repost == true &&
            post.repostComment != null &&
            post.repostComment!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              post.repostComment!,
              style: TextStyle(
                color: isDark ? AppColors.textDark : AppColors.textLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        const SizedBox(height: 6),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${post.user.username} ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
                TextSpan(
                  text: post.caption,
                  style: TextStyle(
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),
      ],
    );
  }
}
