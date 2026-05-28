import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';

import '../../data/models/user_model.dart';

import '../profile/user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  bool loading = false;

  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();

    searchUsers('');
  }

  Future<void> searchUsers(String query) async {
    try {
      setState(() {
        loading = true;
      });

      final response = await ApiService.get('users/search?query=$query');

      final List<dynamic> data = response['data'] ?? [];

      setState(() {
        users = data.map((e) => UserModel.fromJson(e)).toList();
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void openProfile(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserProfileScreen(userId: user.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          onChanged: searchUsers,
          decoration: InputDecoration(
            hintText: 'Buscar usuarios...',
            filled: true,
            fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text('No se encontraron usuarios'))
          : ListView.separated(
              itemCount: users.length,
              separatorBuilder: (_, __) => Divider(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              itemBuilder: (context, index) {
                final user = users[index];

                return ListTile(
                  onTap: () => openProfile(user),
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
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                );
              },
            ),
    );
  }
}
