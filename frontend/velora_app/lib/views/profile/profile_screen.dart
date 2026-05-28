import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';

import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/saved_provider.dart';

import '../auth/login_screen.dart';
import 'follow_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<ProfileProvider>().fetchMyProfile();

      await context.read<SavedProvider>().fetchSavedPosts();
    });
  }

  Future<void> refreshProfile() async {
    await context.read<ProfileProvider>().fetchMyProfile();

    await context.read<SavedProvider>().fetchSavedPosts();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    final savedProvider = context.watch<SavedProvider>();

    final authProvider = context.watch<AuthProvider>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (profileProvider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = profileProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No se pudo cargar el perfil')),
      );
    }

    final postsToShow = selectedTab == 0
        ? profileProvider.posts
        : savedProvider.savedPosts;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
        actions: [
          IconButton(
            onPressed: () async {
              await authProvider.logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshProfile,
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
                          backgroundImage: user.profileImageUrl.isNotEmpty
                              ? NetworkImage(user.profileImageUrl)
                              : null,
                          child: user.profileImageUrl.isEmpty
                              ? Text(
                                  user.username.isNotEmpty
                                      ? user.username[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(fontSize: 26),
                                )
                              : null,
                        ),

                        const SizedBox(width: 24),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _ProfileStat(
                                value: user.postsCount.toString(),
                                label: 'Posts',
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FollowListScreen(
                                        userId: user.id,
                                        title: 'Seguidores',
                                        followers: true,
                                      ),
                                    ),
                                  );
                                },
                                child: _ProfileStat(
                                  value: user.followersCount.toString(),
                                  label: 'Seguidores',
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FollowListScreen(
                                        userId: user.id,
                                        title: 'Seguidos',
                                        followers: false,
                                      ),
                                    ),
                                  );
                                },
                                child: _ProfileStat(
                                  value: user.followingCount.toString(),
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
                        user.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user.bio,
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
                          child: _ProfileTabButton(
                            selected: selectedTab == 0,
                            icon: Icons.grid_on,
                            label: 'Posts',
                            onTap: () {
                              setState(() {
                                selectedTab = 0;
                              });
                            },
                          ),
                        ),

                        Expanded(
                          child: _ProfileTabButton(
                            selected: selectedTab == 1,
                            icon: Icons.bookmark,
                            label: 'Guardados',
                            onTap: () {
                              setState(() {
                                selectedTab = 1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (selectedTab == 1 && savedProvider.loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (postsToShow.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    selectedTab == 0
                        ? 'Aún no tienes publicaciones'
                        : 'Aún no tienes guardados',
                  ),
                ),
              )
            else
              SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final post = postsToShow[index];

                  return GestureDetector(
                    onTap: () {},
                    child: CachedNetworkImage(
                      imageUrl: post.mediaUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                }, childCount: postsToShow.length),
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

class _ProfileTabButton extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileTabButton({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected
                  ? AppColors.accent
                  : isDark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
              width: selected ? 2.5 : 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected
                  ? AppColors.accent
                  : isDark
                  ? AppColors.mutedDark
                  : AppColors.mutedLight,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected
                    ? AppColors.accent
                    : isDark
                    ? AppColors.mutedDark
                    : AppColors.mutedLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
