import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/comments_provider.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CommentsProvider>().fetchComments(widget.postId);
    });
  }

  Future<void> sendComment() async {
    final text = commentController.text.trim();

    if (text.isEmpty) return;

    await context.read<CommentsProvider>().createComment(
      postId: widget.postId,
      content: text,
    );

    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommentsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Comentarios')),
      body: Column(
        children: [
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.comments.isEmpty
                ? const Center(child: Text('Aún no hay comentarios'))
                : ListView.builder(
                    itemCount: provider.comments.length,
                    itemBuilder: (context, index) {
                      final comment = provider.comments[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              comment.user.profileImageUrl.isNotEmpty
                              ? NetworkImage(comment.user.profileImageUrl)
                              : null,
                          child: comment.user.profileImageUrl.isEmpty
                              ? Text(
                                  comment.user.username.isNotEmpty
                                      ? comment.user.username[0].toUpperCase()
                                      : '?',
                                )
                              : null,
                        ),
                        title: Text(
                          comment.user.username,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(comment.content),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un comentario...',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: sendComment,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
