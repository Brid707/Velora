import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/reel_model.dart';
import '../../providers/reels_provider.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ReelsProvider>().fetchReels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReelsProvider>();

    return Scaffold(
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.reels.isEmpty
          ? const Center(child: Text('Aún no hay reels'))
          : PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: provider.reels.length,
              itemBuilder: (context, index) {
                return ReelPlayerCard(reel: provider.reels[index]);
              },
            ),
    );
  }
}

class ReelPlayerCard extends StatefulWidget {
  final ReelModel reel;

  const ReelPlayerCard({super.key, required this.reel});

  @override
  State<ReelPlayerCard> createState() => _ReelPlayerCardState();
}

class _ReelPlayerCardState extends State<ReelPlayerCard> {
  late VideoPlayerController controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.reel.videoUrl),
    );

    controller.initialize().then((_) {
      controller
        ..setLooping(true)
        ..play();

      if (mounted) {
        setState(() {
          initialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleVideo() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ReelsProvider>();

    return Stack(
      fit: StackFit.expand,
      children: [
        initialized
            ? GestureDetector(
                onTap: toggleVideo,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              )
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator()),
              ),

        Positioned(
          right: 14,
          bottom: 120,
          child: Column(
            children: [
              _ActionButton(
                icon: widget.reel.likedByMe
                    ? Icons.favorite
                    : Icons.favorite_border,
                text: widget.reel.likesCount.toString(),
                color: widget.reel.likedByMe ? Colors.red : Colors.white,
                onTap: () {
                  provider.likeReel(widget.reel.id);
                },
              ),
              const SizedBox(height: 18),
              _ActionButton(
                icon: Icons.mode_comment_outlined,
                text: widget.reel.commentsCount.toString(),
                onTap: () {},
              ),
              const SizedBox(height: 18),
              _ActionButton(
                icon: Icons.send_outlined,
                text: 'Enviar',
                onTap: () {},
              ),
              const SizedBox(height: 18),
              _ActionButton(
                icon: Icons.bookmark_border,
                text: 'Guardar',
                onTap: () {},
              ),
            ],
          ),
        ),

        Positioned(
          left: 16,
          right: 90,
          bottom: 42,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundImage: widget.reel.user.profileImageUrl.isNotEmpty
                        ? NetworkImage(widget.reel.user.profileImageUrl)
                        : null,
                    child: widget.reel.user.profileImageUrl.isEmpty
                        ? Text(
                            widget.reel.user.username.isNotEmpty
                                ? widget.reel.user.username[0].toUpperCase()
                                : '?',
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '@${widget.reel.user.username}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.reel.caption,
                style: const TextStyle(color: AppColors.white, fontSize: 14),
              ),
            ],
          ),
        ),

        if (initialized && !controller.value.isPlaying)
          Center(
            child: Icon(
              Icons.play_arrow,
              size: 80,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.text,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
