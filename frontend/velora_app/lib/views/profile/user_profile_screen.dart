import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../data/models/post_model.dart';
import '../../data/models/user_model.dart';
import '../messages/chat_screen.dart';
import 'follow_list_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool loading = true;
  bool following = false;

  UserModel? user;
  List<PostModel> posts = [];

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await ApiService.get('users/${widget.userId}');
      final data = response['data'];

      setState(() {
        user = UserModel.fromJson(data['user']);
        posts = (data['posts'] as List<dynamic>? ?? [])
            .map((e) => PostModel.fromJson(e))
            .toList();
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> toggleFollow() async {
    if (user == null) return;

    await ApiService.post('follows/${user!.id}', {});

    setState(() {
      following = !following;

      final newFollowers = following
          ? user!.followersCount + 1
          : user!.followersCount - 1;

      user = user!.copyWith(
        followersCount: newFollowers < 0 ? 0 : newFollowers,
      );
    });
  }

  void openChat() {
    if (user == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          receiverId: user!.id,
          username: user!.username,
          fullName: user!.fullName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No se pudo cargar el perfil')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(user!.username)),
      body: RefreshIndicator(
        onRefresh: fetchProfile,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: AppColors.accent,
                          backgroundImage: user!.profileImageUrl.isNotEmpty
                              ? NetworkImage(user!.profileImageUrl)
                              : null,
                          child: user!.profileImageUrl.isEmpty
                              ? Text(
                                  user!.username.isNotEmpty
                                      ? user!.username[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _ProfileStat(
                                value: user!.postsCount.toString(),
                                label: 'Posts',
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FollowListScreen(
                                        userId: user!.id,
                                        title: 'Seguidores',
                                        followers: true,
                                      ),
                                    ),
                                  );
                                },
                                child: _ProfileStat(
                                  value: user!.followersCount.toString(),
                                  label: 'Seguidores',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FollowListScreen(
                                        userId: user!.id,
                                        title: 'Seguidos',
                                        followers: false,
                                      ),
                                    ),
                                  );
                                },
                                child: _ProfileStat(
                                  value: user!.followingCount.toString(),
                                  label: 'Siguiendo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user!.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user!.bio,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: toggleFollow,
                            child: Text(following ? 'Siguiendo' : 'Seguir'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: openChat,
                            child: const Text('Mensaje'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Divider(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ],
                ),
              ),
            ),
            if (posts.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text('Este usuario aún no tiene publicaciones'),
                ),
              )
            else
              SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final post = posts[index];

                  return CachedNetworkImage(
                    imageUrl: post.mediaUrl,
                    fit: BoxFit.cover,
                  );
                }, childCount: posts.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
