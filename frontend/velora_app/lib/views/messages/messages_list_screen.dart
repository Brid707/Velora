import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../data/models/user_model.dart';
import 'chat_screen.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  bool loading = true;
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    try {
      final response = await ApiService.get('messages');
      final List<dynamic> data = response['data'] ?? [];

      setState(() {
        users = data.map((e) => UserModel.fromJson(e)).toList();
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
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
    ).then((_) => fetchConversations());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text('Aún no tienes conversaciones'))
          : RefreshIndicator(
              onRefresh: fetchConversations,
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) => Divider(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                itemBuilder: (context, index) {
                  final user = users[index];

                  return ListTile(
                    onTap: () => openChat(user),
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
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
              ),
            ),
    );
  }
}
