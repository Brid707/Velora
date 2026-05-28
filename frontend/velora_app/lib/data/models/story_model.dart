import 'user_model.dart';

class StoryModel {
  final String id;
  final UserModel user;
  final String mediaUrl;
  final String mediaType;
  final bool viewed;
  final String createdAt;

  StoryModel({
    required this.id,
    required this.user,
    required this.mediaUrl,
    required this.mediaType,
    required this.viewed,
    required this.createdAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'].toString(),
      user: UserModel.fromJson(json['user'] ?? {}),
      mediaUrl: json['mediaUrl'] ?? json['imageUrl'] ?? json['videoUrl'] ?? '',
      mediaType: json['mediaType'] ?? 'image',
      viewed: json['viewed'] ?? false,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
