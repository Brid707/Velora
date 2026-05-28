import 'user_model.dart';

class CommentModel {
  final String id;
  final UserModel user;
  final String content;
  final String createdAt;

  CommentModel({
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'].toString(),
      user: UserModel.fromJson(json['user'] ?? {}),
      content: json['content'] ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
