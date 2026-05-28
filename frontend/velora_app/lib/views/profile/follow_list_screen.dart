import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../data/models/user_model.dart';
import '../messages/chat_screen.dart';

class FollowListScreen extends StatefulWidget {
  final String userId;
  final String title;
  final bool followers;

  const FollowListScreen({
    super.key,
    required this.userId,
    required this.title,
    required this.followers,
  });

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  bool loading = true;
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final endpoint = widget.followers
          ? 'follows/${widget.userId}/followers'
          : 'follows/${widget.userId}/following';

      final response = await ApiService.get(endpoint);
      final List<dynamic> data = response['data'] ?? [];

      setState(() {
        users = data.map((e) => UserModel.fromJson(e)).toList();
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> toggleFollow(String targetUserId) async {
    await ApiService.post('follows/$targetUserId', {});
    await fetchUsers();
  }

  void openChat(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          receiverId: user.id,
          username: user.username,
          fullName: user.fullName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? Center(
              child: Text(
                widget.followers
                    ? 'Aún no tiene seguidores'
                    : 'Aún no sigue a nadie',
              ),
            )
          : ListView.separated(
              itemCount: users.length,
              separatorBuilder: (_, __) => Divider(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              itemBuilder: (context, index) {
                final user = users[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.accent,
                    backgroundImage: user.profileImageUrl.isNotEmpty
                        ? NetworkImage(user.profileImageUrl)
                        : null,
                    child: user.profileImageUrl.isEmpty
                        ? Text(
                            user.username.isNotEmpty
                                ? user.username[0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),
                  title: Text(
                    user.username,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(user.fullName),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => openChat(user),
                        child: const Text('Mensaje'),
                      ),
                      FilledButton(
                        onPressed: () => toggleFollow(user.id),
                        child: const Text('Seguir'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
